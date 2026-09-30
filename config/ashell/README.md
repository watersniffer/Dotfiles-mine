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

Two things stock 0.10.0 cannot do, neither of which is expressible in
`config.toml`:

- **No playback progress.** The MediaPlayer menu has a volume slider but no
  progress bar, and MPRIS exposes no signal that would make one cheap to add.
- **No artwork for web players.** Cover art is read from `mpris:artUrl`, which
  web players usually leave unset — Firefox, for instance, reports only a title
  and a URL. YouTube and anime sites do advertise a poster, just not in the one
  place ashell looks.

`patches/0001-media-player-progress-and-artwork.patch` adds both.

### Progress bar

- Reads `mpris:length` from the cached metadata and polls `Position` once a
  second **while the menu is open** (nothing is drawn when it is closed, so
  there is no point polling then).
- Polls *every* player, keyed by MPRIS service name, not just the one shown in
  the bar — the menu draws a card per player.
- Reads `Position` through `org.freedesktop.DBus.Properties.Get` rather than the
  zbus property getter. This matters: zbus serves `#[zbus(property)]` getters
  from an internal cache that only `PropertiesChanged` signals refresh, and
  MPRIS never emits one for `Position`. The cached getter returns the value read
  once at startup, frozen forever, so polling through it silently does nothing.

### Text in the dropdown

The dropdown shows the **full** title, artist and album; long values wrap onto
more lines. The bar indicator is a separate code path and still clips to
`max_text_length` (20 in `config.toml`), because the bar has no room to wrap.

### Artwork

- If a player has no `mpris:artUrl` but does have a `xesam:url`, the page is
  fetched once and its `og:image` (or `twitter:image`) is used as the cover.
  This is what makes Anikoto and YouTube show real posters.
- The discovered URL is written back into `art_url`, so the existing download,
  cache-eviction and rendering paths are reused unchanged.
- **This means the bar makes an outbound HTTP request** to the media page
  whenever a track with no artwork starts — e.g. `anikotv.to`. It is deduped per
  page URL, a page that yields nothing is never retried, it carries a plain
  browser user-agent (several of these sites 403 otherwise), and the read is
  capped at 2 MiB so a multi-megabyte page is abandoned rather than fully
  downloaded.
- When no artwork can be found at all (radio streams publish neither an
  `mpris:artUrl` nor an `og:image`), the card draws a generated tile whose colour
  and initial come from a hash of the track name, so the row is never left with a
  blank gap.

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
- **The progress bar jumps for radio streams.** A stream's `mpris:length` is the
  current track's, and the position resets whenever the track changes.
- **A tile with a single letter instead of a poster.** That is the fallback for
  media that genuinely has no artwork, not a failed fetch — a fetch that is
  still in flight shows a "loading cover" line first, and a real poster replaces
  the tile as soon as it lands.
