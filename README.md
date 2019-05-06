# BEFORE PUSHING REVIEW DIFFS FOR SENSITIVE INFORMATION !!!

# Manjaro System Setup 

This config is based on Manjaro (Architect Edition) instalation. It includes multiple dotfiles, scripts and suckless software configs focused on web development. More than anything this is a collection of personal notes to order installation and configuration process in my head, but if it can be useful for somebody else, all the better! :)

General dependencies: curl, git, nmcli

## OS parts

### Window Manager - [DWM 6.2](https://dwm.suckless.org/)

DWM (Dynamc Window Manager) is part of the [suckless](https://suckless.org/philosophy/) software suite. In order to run it `xorg` needs to be installed and the file `.xinitrc` should contain instruction `exec dwm`. 
For transparency to work it is necesary to install `compton` and launch it via `.xinitrc`. Transparency can be set in `.Xresources` file using value for `\*.alpha` (0-255).
NOTE: I don't use any `display manager` at the moment.  

#### General config 
I used a fork of st created by [Luke Smith](https://github.com/LukeSmithxyz/st) that is already patched with transparency, scroll and some good keybindings.

It works very well and I only made the folowing changes:
* added keybinding to launch Firefox on Alt+Shif+w

#### Status bar configuration (right-hand side)
Status bar can be configured using bash scripts and some system utilities.

[Configuration file](./dwm_status)

Dependencies: xsetroot and system utilities used by scripts.

In order for the configuration to work it needs to be included into the `.xinitrc` file.

#### Workspaces configuration (left-hand side)
This part of the bar is configured inside dwm `config.h` file. See [my example](./dotfiles/dwm.config.h). 

I changed :
* font
* replaced workplaces numbers with icons (you can paste glyphs)
* set default workspace for certain programms (use `xprops` to detect class)
* changed the default size of the main tile in monocle mode. [See dwm docs](https://dwm.suckless.org/tutorial/).

After making changes to the file you need to run `sudo make clean install` in the dwm directory to compile and install in on your system. The chages will take place after login.

# DOCS TODO:
## Important things
- [x] Window manager - dwm
- [ ] Terminal emulator - st
- [ ] Launcher - dmenu
- [ ] File manager - ranger || vifm
- [ ] Browsers - firefox && surf

## Small things
- [ ] fonts
- [ ] icons-in-terminal
- [ ] wallpapers
- [ ] wifi on/off function
- [ ] vim config

# BEFORE PUSHING REVIEW DIFFS FOR SENSITIVE INFORMATION !!!
