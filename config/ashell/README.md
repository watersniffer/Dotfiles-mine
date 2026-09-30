# ashell

Bar for the Hyprland session (niri keeps waybar). Config lives in
`config/ashell/config.toml`; `~/.config/ashell` is a symlink to this directory,
so editing files here takes effect immediately — ashell hot-reloads its config.

## Layout

| Path                          | What it is                                        |
| ----------------------------- | ------------------------------------------------- |
| `config.toml`                 | **Generated** by `local/bin/theme-apply`. Only the `[appearance]` section is rewritten. |
| `scripts/catloop-json.sh`     | cpucat module: emits the sleeping/awake cat frame. |
| `scripts/merge-waycat-font.py`| Builds `WaycatMono` with the cat frames in the Private Use Area. |
| `patches/`                    | Source patches applied to ashell by `build-ashell.sh`. |
| `build-ashell.sh`             | Rebuilds patched ashell and installs it to `/usr/local/bin/ashell`. |

## Why ashell is built from source

ashell 0.10.0 cannot show playback position. Its MediaPlayer menu has a volume
slider but no progress bar, there is no config option for one, and MPRIS exposes
no signal that would make it cheap to add. `patches/0001-media-player-progress-bar.patch`
adds a progress bar to each player card in that menu.

The patch is small but not free, so it is worth knowing what it does:

- Reads `mpris:length` out of the cached metadata and polls `Position` once a
  second **while the menu is open** (nothing is drawn when it is closed, so
  there is no point polling then).
- Polls *every* player, keyed by MPRIS service name, not just the one shown in
  the bar — the menu draws a card per player.
- Reads `Position` through `org.freedesktop.DBus.Properties.Get` rather than the
  zbus property getter. This matters: zbus serves `#[zbus(property)]` getters
  from an internal cache that only `PropertiesChanged` signals refresh, and
  MPRIS never emits one for `Position`. The cached getter returns the value read
  once at startup, frozen forever, so polling through it silently does nothing.

Rebuild after changing any patch:

```sh
config/ashell/build-ashell.sh
kill $(pgrep -x ashell); ashell &
```

`build-ashell.sh` needs `cargo` and `libclang` (Arch: `clang-libs`). libclang is
a build-only dependency and is deliberately not in `packages.txt`. The original
unpatched binary is kept at `/usr/local/bin/ashell.orig-0.10.0`.

When bumping ashell, edit `ASHELL_TAG` at the top of `build-ashell.sh` and
re-run it. The script `git apply --check`s every patch before building, so a
patch that no longer applies fails immediately instead of after a 15-minute
build — rebase it by hand rather than skipping it.

## Things that look wrong but are not

- **Cat glyphs in menu text.** ashell renders every string with one global
  font, so Waycat's A–N would otherwise appear as cats throughout the UI. The
  merged `WaycatMono` puts the cat frames at U+E000–E00B and
  `catloop-json.sh` maps frame letters to those code points.
- **No thumbnail in the menu.** Cover art comes from `mpris:artUrl`, which most
  sources (web video, radio streams) do not provide. Nothing to fix.
- **The progress bar jumps for radio streams.** A stream's `mpris:length` is the
  current track's, and the position resets whenever the track changes.
