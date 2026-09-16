#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Display system info with fastfetch
bash "$HOME/.config/fastfetch/run-fastfetch-kitty.sh"

# SLSsteam: Add wrapper to PATH
export PATH="$HOME/.local/share/SLSsteam/path:$PATH"

