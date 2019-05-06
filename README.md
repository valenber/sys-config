# Manjaro System Setup 

This config is based on Manjaro (Architect Edition) instalation. It includes multiple dotfiles, scripts and suckless software configs focused on web development. More than anything this is a collection of personal notes to order installation and configuration process in my head, but if it can be useful for somebody else, all the better! :)

## OS parts

### Window Manager - [DWM 6.2](https://dwm.suckless.org/)

DWM (Dynamc Window Manager) is part of the [suckless](https://suckless.org/philosophy/) software suite. In order to run it `xorg` needs to be installed and the file `.xinitrc` should contain instruction `exec dwm`. 
NOTE: I don't use any `display manager` at the moment.  

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
* changed the default size of the main tile in monocle mode. [See dwm docs](https://dwm.suckless.org/).

After making changes to the file you need to run `sudo make clean install` in the dwm directory to compile and install in on your system. The chages will take place after login.

# DOCS TODO:
- [x] Window manager - dwm
- [ ] Terminal emulator - st
- [ ] Launcher - dmenu
- [ ] File manager - ranger || vifm
- [ ] Browsers - firefox && surf
