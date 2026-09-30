#!/usr/bin/env python3
"""Patch hyprmod so a Lua-managed config stops getting hyprlang gradient syntax.

Hyprland 0.56 types some colour options as gradients. `hyprctl getoption
decoration:shadow:color` answers with

    gradient data: ee1a1a1a 0deg

and hyprmod 0.15 seeds its option state from exactly that string and writes it
back verbatim. In a Hyprlang config that is correct. In the Lua config this
machine uses, it becomes

    color = "0 0deg"

which Hyprland's Lua parser rejects:

    error setting 'decoration.shadow.color': invalid color "0 0deg"

Because the state is re-seeded from IPC on every session, the error comes back
after every save -- so any change made through the GUI raises it.

The fix is at the serialisation boundary in core/config.py, which is the single
funnel both build_content() and to_managed_text() pass through. Hyprlang keeps
the gradient form; Lua gets a plain 0xAARRGGBB. Idempotent, and re-runnable.
"""
import re
import shutil
import subprocess
import sys
from pathlib import Path

TARGET = Path("/usr/lib/python3.14/site-packages/hyprmod/core/config.py")

HELPER = '''
def _unwrap_gradient_color(value: str) -> str:
    """Rewrite a single-stop hyprlang gradient colour as a plain Lua colour.

    Hyprland reports gradient-typed colour options over IPC as
    ``ee1a1a1a 0deg``. That is valid Hyprlang and invalid Lua, where the same
    value has to be ``0xee1a1a1a``; feeding the first to the Lua parser is what
    produces the "invalid color" error on every save.

    A single stop plus an angle is only a colour with an angle attached, and the
    Lua config has no syntax for the angle, so dropping it loses nothing real.
    Anything with two or more stops -- an actual gradient -- is returned
    untouched, because there is no faithful Lua spelling for it here and
    mangling it would be worse than leaving it.

    Written with str operations rather than re because this module does not
    import re, and adding an import to a distro package for one helper is a
    larger change than it looks.
    """
    v = value.strip()
    if not v.endswith("deg"):
        return value
    head, sep, tail = v[:-3].rpartition(" ")
    if not sep or not head:
        return value
    try:
        float(tail)
    except ValueError:
        return value
    if any(c not in "0123456789abcdefABCDEF" for c in head):
        return value
    return f"0x{head.zfill(8)}"


'''

OLD = '''        _add_section(
            doc,
            "Settings",
            [f"{k} = {v}" for k, v in sorted(values.items())],
        )'''

NEW = '''        # Gradient-typed colours arrive from IPC in hyprlang form ("ee1a1a1a
        # 0deg"), which the Lua parser rejects. Unwrap them for Lua targets
        # only; see _unwrap_gradient_color.
        lua_target = is_lua_target(managed_path())
        setting_lines = [
            f"{k} = {_unwrap_gradient_color(v) if lua_target else v}"
            for k, v in sorted(values.items())
        ]
        _add_section(doc, "Settings", setting_lines)'''

src = TARGET.read_text(encoding="utf-8")

if "_unwrap_gradient_color" in src:
    print("already patched, nothing to do")
    sys.exit(0)

if OLD not in src:
    print("FATAL: anchor not found -- hyprmod changed, refusing to guess")
    sys.exit(1)

if "def _build_document(" not in src:
    print("FATAL: _build_document not found")
    sys.exit(1)

src = src.replace("def _build_document(", HELPER.lstrip("\n") + "def _build_document(", 1)
src = src.replace(OLD, NEW, 1)

shutil.copy2(TARGET, "/home/water/hyprmod-config.py.backup")
TARGET.write_text(src, encoding="utf-8")

r = subprocess.run([sys.executable, "-m", "py_compile", str(TARGET)],
                   capture_output=True, text=True)
if r.returncode != 0:
    shutil.copy2("/home/water/hyprmod-config.py.backup", TARGET)
    print("FATAL: patched file does not compile, rolled back")
    print(r.stderr)
    sys.exit(1)

print("patched and compiles cleanly")
print("backup: /home/water/hyprmod-config.py.backup")
