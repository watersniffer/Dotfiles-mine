# Desktop setup: ashell, theming and wallpapers

The *look and shell* of this desktop — the theme engine, the palette set, the
bar, and the wallpaper tooling — with no applications, no package lists and no
wallpaper images.

Saved as its own branch so it can be used on its own while the full dotfiles
repo carries the rest.

## What is here

```
themes/                     one palette.conf per theme -- the colour source
local/bin/theme-apply       the theme engine: reads a palette, renders it into
                            every app's config (bar, rofi, kitty, nvim, btop,
                            gtk-3/4, qt6ct, waybar, niri, hyprland, ...)
local/bin/themesw           cycles themes; Super+T
local/bin/wallpaper-switcher  Super+W, opens the current theme's wallpaper folder
local/bin/wallpaper-fade    animated wallpaper switching
local/bin/toggle-waybar     Super+Shift+W, hides/shows the bar
config/ashell/              the bar: modules, appearance, and its scripts
config/waybar/              the previous bar, kept for the niri session
config/<app>/...            only the colour/theme files theme-apply writes
```

## What is deliberately not here

- **No packages.** No `packages.txt`, no `install.sh` package lists. This branch
  does not install software.
- **No wallpapers.** `~/Pictures/Wallpapers` holds the images and is not tracked.
- **No `local/bin` utilities** beyond the theming ones (no wallpaper fetchers, no
  prompts, no scratch scripts).
- **`home/.bashrc` and `home/.bash_profile`** are absent from this branch on
  purpose — those carry hand edits that were never meant to be published.

## The theming model

A theme is one `themes/<slug>/palette.conf` holding generic roles:

```
bg0..bg4    surfaces, darkest to lightest
fg0..fg3    text, brightest to dimmest
accent, on_accent, urgent
```

`theme-apply` reads the active theme (recorded in
`~/.local/state/theme-current`) and writes the colours into every app's own
config. Nothing is themed twice: each app's file is the only place its colours
live, and it is regenerated rather than hand-edited.

```bash
themesw                      # cycle to the next theme
theme-apply --current        # print the active theme
theme-apply --wallpapers     # the current theme's wallpaper folder
```

Adding a theme means adding a directory with a `palette.conf`. Every palette
needs all of the keys above or `theme-apply` refuses it.

## bar colours

The bar's geometry and colours come from the same palette via the
`[appearance]` block that `theme-apply` regenerates. **Edit the generator, not
the generated file** — a hand edit there is reverted by the next `themesw`.

Two values in that block are worth knowing, because both were found by measuring
rather than by reading a schema:

- `scale_factor` is the only lever for font size *and* bar height; they move
  together. Measured: 0.90 gives a 34 px bar, 0.75 a 25 px one.
- `[appearance.bar] surface` does nothing. `"solid"` and `"transparent"` render
  byte-identically (same md5), so the capsules you see are painted per module
  and there is no setting that merges them into one shape.
