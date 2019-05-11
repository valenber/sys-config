# BEFORE PUSHING REVIEW DIFFS FOR SENSITIVE INFORMATION !!!

# Manjaro System Setup 

This config is based on Manjaro (Architect Edition) instalation. It includes multiple dotfiles, scripts and suckless software configs focused on web development. More than anything this is a collection of personal notes to order installation and configuration process in my head, but if it can be useful for somebody else, all the better! :)

General dependencies: curl, git, nmcli

## OS configuration

### Hibernation
Hibernation requires a swapfile or partition, I chose to go with a file since it allows to change its size in the future, in case I will need to expand RAM. This section is mainly a summary of [this article](http://blog.programmableproduction.com/2016/02/22/ArchLinux-Powermanagement-Setting-Hibernate/)

#### Create a swap file

Different sources have different opinions about the required size of the **swapfile**. We can use the value stored in the file */sys/power/image_size* that outputs the size of hibernation image. 

* create new file of the size you want - e.g. `sudo fallocate -l 3293M /swapfile`
* set file permissions (owner read/write access) - `sudo chmod 600 /swapfile`
* format as swapfile - `sudo mkswap /swapfile`
* enable swapfile - `sudo swapon /swapfile`
* add swapfile entry to the file *etc/fstab* - `/swapfile none swap defaults 0 0`

#### Configure startup
It is necessary to update the configuration of system boot manager (grub). To do this edit the file */etc/default/grub*.

**Since making a mistake in this configuration can break booting, it's a good idea to make a backup copy**

The line I need to edit is `GRUB_CMDLINE_LINUX_DEFAULT`. 

Hibernation requires `resume` and `resume_offset` instructions. The later is only needed if we are using swapfile rather than partition.

* `resume=/dev/sda2` points to the partition where our swapfile is located.
* `resume_offset=464896` points to the disk fragment where swapfile starts.

To find the fragment number we can use `sudo filefrag -v /swapfile` command that outputs the file fragments table. The number we need is the first one in *physical_offset* column.

After saving the file we need to generate new grub configuration using command `sudo grub-mkconfig -o /boot/grub/grub.cfg`

#### Update mkinitcpio and generate new image
`mkinitcpio` is a bash script that configures initial ramdisk environment. Add `resume` to startup hook, so the system can be restored from hibernation. 

* Edit the uncommented `HOOKS=()` list in the file */etc/mkinitcpio.conf* and add resume to what's already in the list.
* Generate updated base image - `sudo mkinitcpio -p [image_name]`
You can see the name of your image in the folder */etc/mkinitcpio.d/*

#### Enable *systemd* handle
This will allow user to trigger hibernation with certain system events.

In the file */etc/systemd/logind.conf* uncomment the line `HandleLidSwitch` and set its value to `hibernate`. This will trigger the hibernation when the laptop is closed. You can also setup other hooks in this file, e.g. `IdleAction` & `IdleActionSec`.


## OS components

### Window Manager - [dwm 6.2](https://dwm.suckless.org/)

DWM (Dynamc Window Manager) is part of the [suckless](https://suckless.org/philosophy/) software suite. In order to run it `xorg` needs to be installed and the file `.xinitrc` should contain instruction `exec dwm`. 
NOTE: I don't use any `display manager` at the moment.  


#### Status bar configuration (right-hand side)
Status bar can be configured using bash scripts and some system utilities.

[Configuration file](./dwm_status)

Dependencies: `xsetroot` and system utilities used by scripts.

In order for the configuration to work it needs to be included into the `.xinitrc` file.

#### Workspaces configuration (left-hand side)
This part of the bar is configured inside dwm `config.h` file. See [my example](./dotfiles/dwm.config.h). 

I changed :
* font
* replaced workplaces numbers with icons (you can paste glyphs)
* set default workspace for certain programms (use `xprops` to detect class)
* changed the default size of the main tile in monocle mode. [See dwm docs](https://dwm.suckless.org/tutorial/).
* added keybinding to launch Firefox on Alt+Shif+w

After making changes to the file you need to run `sudo make clean install` in the dwm directory to compile and install in on your system. The chages will take place after login.



### Terminal Emulator - [st](https://st.suckless.org/)
st is another product of suckless community. It's very lightweight and fast and, so far does everything I need.
I used a fork of st created by [Luke Smith](https://github.com/LukeSmithxyz/st) that is already patched with transparency, scroll and some good keybindings.
For transparency to work it is necesary to install `compton` and launch it via `.xinitrc`. Transparency can be set in `.Xresources` file using value for `\*.alpha` (0-255).


# DOCS TODO:
## Important things
- [x] Window manager - dwm
- [x] Terminal emulator - st
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
