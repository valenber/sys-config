#!/bin/fish
#  Fish shell configuration file
#  this should be linked to ~/.config/fish/

# SHELL SETTINGS
# --------------

# enable vim mode for shell with 'jk' working as Escape key
fish_vi_mode
function my_vi_bindings
  fish_vi_key_bindings
  bind -M insert -m default jk backward-char force-repaint
end
set -g fish_key_bindings my_vi_bindings

# INTERGRATIONS
# -------------

# make icon variables available in shell
source ~/.local/share/icons-in-terminal/icons.fish


# ALIASES
# -------

alias gs="git status"
alias vim="nvim"

# FUNCTIONS
# ---------

# turn wifi on and connect using nmcli
function wifi_on
	echo "Attempting to connect to $argv[1]..."
	nmcli radio wifi on
	sleep 10s
	nmcli device wifi connect $argv[1] password $argv[2]
end

# turn wifi off
function wifi_off
	nmcli radio wifi off
end
