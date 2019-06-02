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

### Language
To add another input language I used the following command in *.xinitrc* file:
'setxkbmap -model pc105 -layout us,ru -option grp:ctrl_shift_toggle'.
Don't forget to add '&' at the end, so subsequent instructions inside *.xinitrc* continue executing.


## Touchpad config
In order to contrl the touchpad configuration we need to have `libinput` package installed in the system. Then configuration is done by editing `/usr/share/X11/xorg.conf.d/40-libinput.conf` file. Each section is responsible for specific device in our system and we can add Option line to change default configuration e.g.:
```
 Section "InputClass"
      Identifier "libinput touchpad catchall"
      MatchIsTouchpad "on"
      MatchDevicePath "/dev/input/event*"
      Option "Tapping" "on"
      Driver "libinput"
 EndSection
```


## Fish abbreviations
To speed-up common tasks we can add abbreviations for the shell inside `config.fish` file. For example to always get detaile listing of the directory we can use
```
abbr ls 'ls -la'
```

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

I changed:
* font
* replaced workplaces numbers with icons (you can paste glyphs)
* set default workspace for certain programms (use `xprops` to detect class)
* changed the default size of the main tile in monocle mode. [See dwm docs](https://dwm.suckless.org/tutorial/).
* added keybinding to launch Firefox on Alt+Shift+w
* added keybinding to launch Chrome on Alt + w (inside Chrome setting you can set urls the browser should open on launch. I used it to launch web versions of the chat apps I habitually use)
* added keybindings for system volume control
* added keybindings for screen brightness control

After making changes to the file you need to run `sudo make clean install` in the dwm directory to compile and install in on your system. The chages will take place after login.


### Terminal Emulator - [st](https://st.suckless.org/)
st is another product of suckless community. It's very lightweight and fast and, so far does everything I need.
I used a fork of st created by [Luke Smith](https://github.com/LukeSmithxyz/st) that is already patched with transparency, scroll and some good keybindings.
For transparency to work it is necesary to install `compton` and launch it via `.xinitrc`. Transparency can be set in `.Xresources` file using value for `\*.alpha` (0-255).


### Screen locker - [slock](https://tools.suckless.org/slock/)
Very minimalistic screen locker. After downloading set `user` and `group` in *config.h* and run `sudo make clean install`, then execute `slock` to lock your screen. 
Config also allows to change the colors.

### SSH config
In order to access my personal and work remote code repositories I need to configure two ssh-keys.
The second key is generated in a standard manner (`ssh-keygen`) and just saved with different name. To use specific key for specific host a rule needs to be added to `.ssh/config` file, e.g.:

```
Host WorkRepo
  HostName bitbucket.com
  User officeUser
  IdentityFile ~/.ssh/id_rsa_work


Host Others
  HostName *
  User personalUser
  IdentityFile ~/.ssh/id_rsa

```
It is also necessary to add a script to shell configuration that starts-up ssh-agent and adds keys to it. See [config.fish](./dotfiles/config.fish).


### Custom scripts
If you want to extend or combine functionality of some command in your system, a good way to do it is to add a custom bash script. You can write your logic into a file, copy it into /usr/bin/ folder and make it executable. After this the name of the file becomes a command that can be run inside your shell. It can accept parametres and generaly behaves like any other command you execute in a shell.
See [custom_scripts folder](./custom_scripts/) for examples.

