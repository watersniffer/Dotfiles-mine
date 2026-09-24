#!/bin/bash
# ============================================================================
# Dotfiles Installer - Arch Linux (Hyprland)
# ============================================================================
# Based on water's custom Hyprland setup with:
#   Bash + Starship, Kitty, Neovim (lazy.nvim), Waybar,
#   Rofi, Mako, optional Matugen theming, tmux, and many utilities.
#
# Usage:
#   chmod +x install.sh
#   ./install.sh              # Full install
#   ./install.sh --skip-pkgs  # Skip packages; still apply configs/system settings
#   ./install.sh --help
# ============================================================================

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'

log()  { echo -e "${BLUE}::${NC} $*"; }
ok()   { echo -e "${GREEN}[ok]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC} $*"; }
err()  { echo -e "${RED}[error]${NC} $*" >&2; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
SKIP_PKGS=0

for arg in "$@"; do
    case "$arg" in
        --skip-pkgs) SKIP_PKGS=1 ;;
        --help|-h)
            echo "Usage: $0 [--skip-pkgs] [--help]"
            exit 0
            ;;
        *) err "Unknown option: $arg"; exit 1 ;;
    esac
done

# ============================================================================
# 0. PRE-FLIGHT CHECKS
# ============================================================================
preflight() {
    log "Running pre-flight checks..."
    if [[ ! -f /etc/os-release ]] || ! grep -q "ID=arch" /etc/os-release; then
        err "This script is designed for Arch Linux only."; exit 1
    fi
    if [[ "$EUID" -eq 0 ]]; then
        err "Do not run as root. It uses sudo when needed."; exit 1
    fi
    # -n first: reuse an already-cached timestamp (works with no TTY, e.g. when
    # run from a script/CI). Falls back to interactive -v so a normal terminal
    # run still prompts the user for their password.
    if ! sudo -n -v 2>/dev/null && ! sudo -v 2>/dev/null; then
        err "Need sudo access. Run 'sudo -v' first."
        exit 1
    fi
    ok "Pre-flight checks passed."
}

# ============================================================================
# 1. PACMAN PACKAGES
# ============================================================================
install_pacman_packages() {
    log "Installing pacman packages..."

    # Enable multilib if missing. Handle both commented and absent sections.
    local pacman_conf_changed=0
    if ! grep -qE '^[[:space:]]*\[multilib\][[:space:]]*$' /etc/pacman.conf; then
        log "Enabling [multilib] repository..."
        if grep -qE '^[[:space:]]*#[[:space:]]*\[multilib\]' /etc/pacman.conf; then
            sudo sed -i \
                '/^[[:space:]]*#[[:space:]]*\[multilib\]/,/^[[:space:]]*#[[:space:]]*Include/s/^[[:space:]]*#[[:space:]]*//' \
                /etc/pacman.conf
        else
            printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' \
                | sudo tee -a /etc/pacman.conf >/dev/null
        fi
        pacman_conf_changed=1
    fi

    # Ensure the section has the standard mirror Include line.
    if ! awk '
        /^[[:space:]]*\[multilib\][[:space:]]*$/ { in_section=1; next }
        /^[[:space:]]*\[/ { in_section=0 }
        in_section && /^[[:space:]]*Include[[:space:]]*=[[:space:]]*\/etc\/pacman\.d\/mirrorlist[[:space:]]*$/ { found=1 }
        END { exit(found ? 0 : 1) }
    ' /etc/pacman.conf; then
        sudo sed -i '/^[[:space:]]*\[multilib\][[:space:]]*$/a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
        pacman_conf_changed=1
    fi

    [[ "$pacman_conf_changed" -eq 1 ]] && sudo pacman -Sy

    local packages=()
    while IFS= read -r line; do
        line="${line%%#*}"; line="$(echo "$line" | xargs)"
        [[ -n "$line" ]] && packages+=("$line")
    done < "$DOTFILES_DIR/packages.txt"

    local to_install=()
    for pkg in "${packages[@]}"; do
        pacman -Qi "$pkg" &>/dev/null || to_install+=("$pkg")
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        log "Installing ${#to_install[@]} packages..."
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
    else
        ok "All pacman packages already installed."
    fi
}

# ============================================================================
# 2. AUR HELPER (yay)
# ============================================================================
install_yay() {
    if command -v yay &>/dev/null; then ok "yay already installed."; return; fi
    log "Installing yay..."
    local tmpdir; tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    ok "yay installed."
}

# ============================================================================
# 3. AUR PACKAGES
# ============================================================================
install_aur_packages() {
    log "Installing AUR packages..."
    local packages=()
    while IFS= read -r line; do
        line="${line%%#*}"; line="$(echo "$line" | xargs)"
        [[ -n "$line" ]] && packages+=("$line")
    done < "$DOTFILES_DIR/packages-aur.txt"

    local to_install=()
    for pkg in "${packages[@]}"; do
        pacman -Qi "$pkg" &>/dev/null || to_install+=("$pkg")
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        yay -S --needed --noconfirm "${to_install[@]}"
    else
        ok "All AUR packages already installed."
    fi
}

# ============================================================================
# 4. FLATPAK PACKAGES
# ============================================================================
install_flatpak_packages() {
    command -v flatpak &>/dev/null || { warn "Flatpak not installed, skipping."; return; }
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
    while IFS= read -r app; do
        app="$(echo "$app" | xargs)"
        [[ -z "$app" || "$app" == "#"* ]] && continue
        flatpak list --app | grep -q "$app" || flatpak install -y flathub "$app" 2>/dev/null || warn "Failed: $app"
    done < "$DOTFILES_DIR/packages-flatpak.txt"
}

# ============================================================================
# 5. TMUX PLUGIN MANAGER (TPM)
# ============================================================================
install_tpm() {
    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then ok "TPM already installed."; return; fi
    log "Installing TPM..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

# ============================================================================
# 7. SYMLINK DOTFILES
# ============================================================================
link_item() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"

    # Already linked to the right place? Leave it alone (idempotent re-runs).
    if [[ -L "$dst" ]] && [[ "$(readlink -f "$dst" 2>/dev/null)" == "$(readlink -f "$src" 2>/dev/null)" ]]; then
        return 0
    fi

    # Backup if exists
    if [[ -e "$dst" || -L "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        local backup_name
        backup_name=$(echo "$dst" | sed "s|$HOME/||" | tr '/' '_')
        cp -a "$dst" "$BACKUP_DIR/$backup_name" 2>/dev/null || true
        rm -rf "$dst"
    fi

    ln -sf "$src" "$dst"
}

symlink_dotfiles() {
    log "Symlinking dotfiles..."

    # --- Home dotfiles ---
    for f in .tmux.conf .bashrc .bash_profile .bash_logout .vimrc; do
        link_item "$DOTFILES_DIR/home/$f" "$HOME/$f"
    done
    # ~/.vim holds only colorschemes - safe to link wholesale.
    link_item "$DOTFILES_DIR/home/.vim" "$HOME/.vim"

    # --- Config directories (symlinked so live edits flow back into the repo) ---
    local conf_dir="$DOTFILES_DIR/config"
    # nvim and qt6ct are deliberately absent: applications write state into them
    # (see setup_nvim and setup_qt6ct).
    for name in hypr kitty waybar rofi mako fastfetch matugen matuwall wlogout npm \
                xdg-desktop-portal gtk-3.0 gtk-4.0 btop Kvantum xsettingsd; do
        if [[ -d "$conf_dir/$name" ]]; then
            link_item "$conf_dir/$name" "$HOME/.config/$name"
        fi
    done

    # --- Config files ---
    for f in starship.toml electron-flags.conf powermenu.rasi mimeapps.list user-dirs.dirs; do
        [[ -f "$conf_dir/$f" ]] && link_item "$conf_dir/$f" "$HOME/.config/$f"
    done

    # --- Custom scripts (merge, never wipe: ~/.local/bin also holds
    # machine-local tools - uv, tree-sitter, uv-tool shims - that must survive) ---
    mkdir -p "$HOME/.local/bin"
    if [[ -d "$DOTFILES_DIR/local/bin" ]]; then
        cp -a "$DOTFILES_DIR/local/bin/." "$HOME/.local/bin/"
        # startup/ is fully repo-managed: mirror it exactly so retired scripts
        # (e.g. post_install.sh) stop running instead of merging forever.
        rm -rf "$HOME/.local/bin/startup"
        cp -a "$DOTFILES_DIR/local/bin/startup" "$HOME/.local/bin/startup"
        rm -rf "$HOME/.local/bin/__pycache__"
        find "$HOME/.local/bin" -type f -exec chmod +x {} +
    fi

    # --- Custom fonts ---
    mkdir -p "$HOME/.local/share/fonts"
    [[ -f "$DOTFILES_DIR/config/waybar/scripts/fonts/Skulltype.ttf" ]] && cp -f "$DOTFILES_DIR/config/waybar/scripts/fonts/Skulltype.ttf" "$HOME/.local/share/fonts/"
    [[ -f "$DOTFILES_DIR/config/waybar/scripts/fonts/Waycat.ttf" ]]    && cp -f "$DOTFILES_DIR/config/waybar/scripts/fonts/Waycat.ttf" "$HOME/.local/share/fonts/"
    fc-cache -f 2>/dev/null || true

    # --- Wallpaper directory ---
    mkdir -p "$HOME/Pictures/Wallpapers"
    if [[ -d "$DOTFILES_DIR/wallpapers" ]]; then
        cp -an "$DOTFILES_DIR/wallpapers/." "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
    fi

    ok "Dotfiles linked."
}

# ============================================================================
# 8. SYSTEM CONFIGS (requires sudo)
# ============================================================================
apply_system_configs() {
    log "Applying system-wide configs..."

    [[ -f "$DOTFILES_DIR/system/etc/systemd/system/cpu-performance.service" ]] && {
        sudo cp "$DOTFILES_DIR/system/etc/systemd/system/cpu-performance.service" /etc/systemd/system/
        sudo systemctl enable cpu-performance.service
        ok "CPU performance governor enabled."
    }

    [[ -d "$DOTFILES_DIR/system/etc/sddm.conf.d" ]] && {
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp "$DOTFILES_DIR/system/etc/sddm.conf.d/"* /etc/sddm.conf.d/
        ok "SDDM configs applied."
    }

    # SDDM theme: GitHub-only (NOT in AUR). matugen/apply.sh publishes
    # theme.conf + wallpaper into this dir as the login user, hence the chown.
    local sddm_theme_dir="/usr/share/sddm/themes/gruvbox-minimal-sddm"
    if [[ ! -d "$sddm_theme_dir" ]]; then
        log "Installing gruvbox-minimal-sddm theme..."
        local tmp_sddm
        tmp_sddm=$(mktemp -d)
        if git clone --depth 1 https://github.com/scientiac/gruvbox-minimal-sddm "$tmp_sddm/theme"; then
            sudo mkdir -p /usr/share/sddm/themes
            sudo cp -a "$tmp_sddm/theme" "$sddm_theme_dir"
            ok "SDDM theme installed."
        else
            warn "Could not fetch gruvbox-minimal-sddm - clone it manually (see post-install)."
        fi
        rm -rf "$tmp_sddm"
    fi

    # Qt 5.15 uses QtGraphicalEffects for FastBlur. Patch both freshly cloned
    # and pre-existing themes so re-runs also repair older installations.
    if [[ -f "$sddm_theme_dir/Main.qml" ]] && \
       sudo grep -q '^import Qt5Compat\.GraphicalEffects$' "$sddm_theme_dir/Main.qml"; then
        sudo sed -i 's/^import Qt5Compat\.GraphicalEffects$/import QtGraphicalEffects 1.0/' \
            "$sddm_theme_dir/Main.qml"
        ok "SDDM Qt5 import patched."
    fi
    if [[ -d "$sddm_theme_dir" ]]; then
        sudo chown -R "$USER" "$sddm_theme_dir"
    fi

    # Zram
    [[ -f "$DOTFILES_DIR/system/etc/zram-generator.conf" ]] && {
        sudo mkdir -p /etc/systemd
        sudo cp "$DOTFILES_DIR/system/etc/zram-generator.conf" /etc/systemd/zram-generator.conf
        ok "zram config applied."
    }

    # Enable key system services
    sudo systemctl enable sddm.service 2>/dev/null || true
    sudo systemctl enable NetworkManager.service 2>/dev/null || true
    sudo systemctl enable bluetooth.service 2>/dev/null || true
    ok "System services enabled."
}

# ============================================================================
# 9. USER SYSTEMD SERVICES
# ============================================================================
setup_user_services() {
    log "Setting up user systemd services..."

    mkdir -p "$HOME/.config/systemd/user"

    # NB: systemd/user/pipewire-session-manager.service is byte-identical to the
    # stock /usr/lib/systemd/user/wireplumber.service but under a different unit
    # name. Copying it makes systemd run TWO wireplumber instances that fight over
    # the PipeWire core, which hangs wpctl/pwcli and breaks audio. Skip it.
    local SKIP_UNITS="pipewire-session-manager.service"
    local f base
    for f in "$DOTFILES_DIR/systemd/user/"*.service "$DOTFILES_DIR/systemd/user/"*.path \
             "$DOTFILES_DIR/systemd/user/"*.timer; do
        [[ -f "$f" ]] || continue
        base="$(basename "$f")"
        if [[ " $SKIP_UNITS " == *" $base "* ]]; then
            log "Skipping $base (duplicate of stock wireplumber.service)."
            continue
        fi
        cp -f "$f" "$HOME/.config/systemd/user/"
    done

    systemctl --user enable pipewire.service 2>/dev/null || true
    systemctl --user enable pipewire-pulse.service 2>/dev/null || true
    systemctl --user enable wireplumber.service 2>/dev/null || true

    ok "User services configured."
}

# ============================================================================
# 10. NVIM SETUP
# ============================================================================
setup_nvim() {
    local src="$DOTFILES_DIR/config/nvim"
    local dst="$HOME/.config/nvim"

    # nvim must be a REAL dir (it writes current-theme.txt / lazy-lock.json),
    # so materialise a copy instead of leaving a symlink.
    if [[ -L "$dst" ]]; then
        rm -f "$dst"                    # drop the symlink only (target stays in repo)
    fi
    if [[ ! -d "$dst" && -d "$src" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -a "$src" "$dst"
    fi

    mkdir -p "$dst"

    # Ensure theme file exists (theme-loader falls back to this)
    if [[ ! -f "$dst/current-theme.txt" ]]; then
        echo "monochrome" > "$dst/current-theme.txt"
    fi

    ok "Neovim ready. Plugins install on first launch."
}

# ============================================================================
# QT6CT SETUP
# ============================================================================
setup_qt6ct() {
    local src="$DOTFILES_DIR/config/qt6ct"
    local dst="$HOME/.config/qt6ct"

    # qt6ct rewrites qt6ct.conf and its colour settings when launched, so keep
    # it as a real directory rather than letting those writes dirty the repo.
    if [[ -L "$dst" ]]; then
        local tmp_dst
        tmp_dst=$(mktemp -d "$HOME/.config/.qt6ct.XXXXXX")
        cp -a "$src/." "$tmp_dst/"
        rm -f "$dst"
        mv "$tmp_dst" "$dst"
    elif [[ ! -d "$dst" && -d "$src" ]]; then
        cp -a "$src" "$dst"
    fi

    ok "qt6ct configuration ready."
}

# ============================================================================
# GTK / ICON THEME VIA DCONF (GNOME + Cinnamon apps, e.g. Nemo)
# ============================================================================
setup_gtk_dconf() {
    command -v gsettings &>/dev/null || { warn "gsettings missing, skipping dconf theming."; return 0; }
    if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
        warn "No session bus - dconf theming skipped (run again from a login session)."
        return 0
    fi
    gsettings set org.gnome.desktop.interface gtk-theme Kripton 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme Papirus 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Classic 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 11' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 11' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font 12' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null || true
    gsettings set org.gnome.desktop.interface accent-color slate 2>/dev/null || true
    gsettings set org.cinnamon.desktop.interface gtk-theme Kripton 2>/dev/null || true
    gsettings set org.cinnamon.desktop.interface icon-theme Papirus 2>/dev/null || true
    gsettings set org.cinnamon.desktop.interface cursor-theme Bibata-Modern-Classic 2>/dev/null || true
    gsettings set org.cinnamon.desktop.interface font-name 'JetBrainsMono Nerd Font 9' 2>/dev/null || true
    ok "GTK/icon/cursor theme set in dconf (GNOME + Cinnamon)."
}

# ============================================================================
# 11. MISC
# ============================================================================
setup_misc() {
    # GTK2 legacy settings file: seed once if absent (nwg-look may rewrite it
    # in place afterwards - fine, it regenerates from the same dconf values).
    if [[ ! -f "$HOME/.gtkrc-2.0" && -f "$DOTFILES_DIR/home/.gtkrc-2.0" ]]; then
        sed "s|@HOME@|$HOME|g" "$DOTFILES_DIR/home/.gtkrc-2.0" > "$HOME/.gtkrc-2.0"
    fi

    # Create custom XDG dirs from our user-dirs.dirs without overwriting it
    if [[ -f "$HOME/.config/user-dirs.dirs" ]]; then
        local dirs
        dirs=$(grep -oP 'XDG_[A-Z_]+_DIR="\K[^"]+' "$HOME/.config/user-dirs.dirs" 2>/dev/null || true)
        while IFS= read -r d; do
            if [[ "$d" == "/"* ]]; then
                mkdir -p "$d"
            elif [[ "$d" == \$HOME/* ]]; then
                mkdir -p "${d/\$HOME/$HOME}"
            fi
        done <<< "$dirs"
    fi

    local current_shell
    current_shell=$(getent passwd "$USER" | cut -d: -f7)
    if [[ "$current_shell" != *"bash"* ]]; then
        log "Setting bash as default shell..."
        # chsh prompts on the TTY (unavailable when run from scripts), so fall
        # back to usermod, which authenticates via sudo instead.
        if ! chsh -s /usr/bin/bash </dev/tty >/dev/null 2>&1; then
            sudo usermod -s /usr/bin/bash "$USER"
        fi
        ok "Default shell set to bash."
    fi
}

# ============================================================================
# MAIN
# ============================================================================
main() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  Dotfiles Installer — Arch Linux       ${NC}"
    echo -e "${CYAN}  Hyprland + Bash + Kitty + Neovim      ${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""

    preflight

    if [[ "$SKIP_PKGS" -eq 0 ]]; then
        install_pacman_packages
        install_yay
        install_aur_packages
        install_flatpak_packages
    fi

    install_tpm
    symlink_dotfiles
    setup_nvim
    setup_qt6ct
    apply_system_configs
    setup_user_services
    setup_misc
    setup_gtk_dconf

    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Installation complete!                  ${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "  What to do next:"
    echo -e "    1. Log out and back in (for bash + wayland)"
    echo -e "    2. Wallpapers are copied to ~/Pictures/Wallpapers/; add more there, then Super+W (Matuwall)"
    echo -e "    3. Open kitty - nvim plugins install on first launch"
    echo -e "    4. SDDM theme (gruvbox-minimal-sddm) installs automatically;"
    echo -e "       re-run ~/.config/matugen/apply.sh <wallpaper> to publish colors"
    echo -e "    5. Binds: Super+E yazi | Super+, smile | Super+C clipboard | Super+P menu"
    echo -e "       Machine-local extras (uv tools, tree-sitter) - see README"
    echo ""
}

main "$@"
