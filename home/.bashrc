# ============================================================
#  .bashrc  —  migrated from zsh 2026-09-22
#  (oh-my-zsh / powerlevel10k / zsh-vi-mode are zsh-only and
#   were not carried over; starship replaces p10k)
# ============================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return ;;
esac

# === SYSTEM FETCH ===
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
fi

# === PROMPT ===
# powerlevel10k is zsh-only; starship is installed and already configured.
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='[\u@\h \W]\$ '
fi

# === ENVIRONMENT VARIABLES ===
if [ -n "$SSH_CONNECTION" ]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
export PATH="$HOME/.local/bin:$PATH"

# === ALIASES ===
alias ws='cd ~/facu-workspace/'
alias tk='tmux kill-server'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# === CUSTOM FUNCTIONS ===
all-update() {
    local STATE_FILE="$HOME/.config/quickshell/state.json"
    local AUR_HELPER="yay"

    if command -v jq >/dev/null 2>&1 && [[ -f "$STATE_FILE" ]]; then
        local HELPER
        HELPER=$(jq -r '.system.aurHelper // "yay"' "$STATE_FILE")
        if [[ -n "$HELPER" && "$HELPER" != "null" ]]; then
            AUR_HELPER="$HELPER"
        fi
    fi

    echo -e "\e[1;34m:: Updating system packages (pacman)...\e[0m"
    sudo pacman -Syu

    echo -e "\e[1;34m:: Updating AUR packages ($AUR_HELPER)...\e[0m"
    "$AUR_HELPER" -Syu

    if command -v flatpak >/dev/null 2>&1; then
        echo -e "\e[1;34m:: Updating Flatpak packages...\e[0m"
        flatpak update
    fi

    echo -e "\e[1;32m:: All updates complete!\e[0m"
}

# SLSsteam: Add wrapper to PATH
export PATH="$HOME/.local/share/SLSsteam/path:$PATH"
