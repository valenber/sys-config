#!/bin/fish
#  Fish shell configuration file
#  this should be linked to ~/.config/fish/


# SSH-AGENT launch and add all keys on startup 
# --------------------------------------------

setenv SSH_ENV $HOME/.ssh/environment

function start_agent                                                                                                                                                                    
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV 
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities                                                                                                                                                                
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]

        ssh-add ~/.ssh/id_rsa*
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ] 
    ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end  
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end  
    ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else 
        start_agent
    end  
end

# SHELL SETTINGS
# --------------

# enable vim mode for shell with 'jk' working as Escape key
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
