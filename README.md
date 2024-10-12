<div align="center">
  <img src="https://img.shields.io/github/last-commit/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=b4befe" alt="GitHub last commit">
  <img src="https://img.shields.io/github/repo-size/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=cba6f7" alt="GitHub repo size">
</div>


# Dotfiles
Hello, I created these dotfiles to use the BSPWM window manager. The idea came up when I decided to install a minimal version of Debian. Why? I'm not sure, it was a bit of a crazy impulse, but I stuck with the idea, and it eventually evolved. In the end, I decided to create these dotfiles to use them in minimal environments of Debian-based distributions like Kali Linux, Parrot, Ubuntu, and others.

These dotfiles have been tested on the following distributions: Debian and Kali Linux.

> NOTE: Don't use the installer, it contains some problems. Please, if you want to use my dotfiles, use the files manually.


## Pre-installation
As of **October 2024**, if you are using **Debian 12**, some packages may not be available. Therefore, it is recommended to update the kernel and migrate to an environment with **Debian 13 (Trixie)** by performing a full system upgrade.

To do this, you can use the script located in the `debian_bookworm_to_trixie.sh` directory, and once the upgrade is complete, continue with the installation.

You can start by reviewing the packages using the `install_packages` function, editing it to check if the packages are available in the repositories. This is useful if you prefer not to upgrade to Debian 13 (Trixie).


## Installation
```bash
    git clone https://github.com/edgar-ramxs/dotfiles-bspwm.git ~/dotfiles-bspwm
    cd ~/dotfiles-bspwm
    chmod +x installer.sh
    ./installer.sh
```


## Details
<img src="assets/2024-07-30_23-24.png" align="right" width="400px" style="padding: 10px;">

- 💻 **Window Manager** : [Bspwm](https://github.com/baskerville/bspwm)
- 🐱 **Terminal** : [Kitty](https://sw.kovidgoyal.net/kitty/)
- 🦊 **Shell** : [Zsh](https://ohmyz.sh/)
- 🎼 **Compositor** : [Picom](https://github.com/yshui/picom)
- 💈 **Bar** : [Polybar](https://github.com/polybar/polybar)
- 🔍 **Menu Launcher** : [Rofi](https://github.com/davatorium/rofi)
- 🔔 **Notify Daemon** : [Dunst](https://github.com/dunst-project/dunst)
- 📝 **Editor** : [Visual Studio Code](https://code.visualstudio.com/)
- 🚀 **Browser** : [Firefox](https://www.mozilla.org/)
- 📂 **File Manager** : [Thunar](https://wiki.archlinux.org/title/Thunar)
- 🎨 **Wallpaper Manager** : [Nitrogen](https://wiki.archlinux.org/title/Nitrogen)


## Visuals
<img src="assets/2024-07-30_22-43.png" alt="Camila" align="center">


## To Do's
- [x] Scratch my balls
- [ ] Terminate the automatic installer
- [ ] Adapt the dotfiles for all possible Debian based distros


## Keybindings

## Credits


