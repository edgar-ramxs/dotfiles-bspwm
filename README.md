<div align="center">
  <img src="https://img.shields.io/github/last-commit/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=b4befe" alt="GitHub last commit">
  <img src="https://img.shields.io/github/repo-size/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=cba6f7" alt="GitHub repo size">
</div>


# Dotfiles
Hello, I created these dotfiles to use the BSPWM window manager. The idea came up when I decided to install a minimal version of Debian. Why? I'm not sure, it was a bit of a crazy impulse, but I stuck with the idea, and it eventually evolved. In the end, I decided to create these dotfiles to use them in minimal environments of Debian-based distributions like Kali Linux, Parrot, Ubuntu, and others.

- These dotfiles have been tested on the following distributions:
  + [Debian](https://www.debian.org/)
  + [Kali Linux](https://www.kali.org/)

> NOTE: Don't use the installer, it contains some problems. Please, if you want to use my dotfiles, use the files manually.


## Pre-installation
As of **October 2024**, if you are using **Debian 12**, some packages may not be available. Therefore, it is recommended to update the kernel and migrate to an environment with **Debian 13 (Trixie)** by performing a full system upgrade.

To do this, you can use the script located in the `debian_bookworm_to_trixie.sh` directory, and once the upgrade is complete, continue with the installation.

You can start by reviewing the packages using the `install_packages` function, editing it to check if the packages are available in the repositories. This is useful if you prefer not to upgrade to Debian 13 (Trixie).

## Post-installation
> read [KEYBINDING.md](KEYBINDING.md)

## Installation
```bash
    git clone https://github.com/edgar-ramxs/dotfiles-bspwm.git ~/dotfiles-bspwm
    cd ~/dotfiles-bspwm
    chmod +x installer.sh
    ./installer.sh
```


## Details
<div align="center">

  |     | Component                 | Package                                                     |
  | --- | ------------------------- | ----------------------------------------------------------- |
  | 💻 | **Window Manager**         |  [Bspwm](https://github.com/baskerville/bspwm)              |
  | 🐱 | **Terminal**               |  [Kitty](https://sw.kovidgoyal.net/kitty/)                  |
  | 🦊 | **Shell**                  |  [Zsh](https://ohmyz.sh/)                                   |
  | 🎼 | **Compositor**             |  [Picom](https://github.com/yshui/picom)                    |
  | 💈 | **Bar**                    |  [Polybar](https://github.com/polybar/polybar)              |
  | 🔍 | **Menu Launcher**          |  [Rofi](https://github.com/davatorium/rofi)                 |
  | 🔔 | **Notify Daemon**          |  [Dunst](https://github.com/dunst-project/dunst)            |
  | 📝 | **Editor**                 |  [Visual Studio Code](https://code.visualstudio.com/)       |
  | 🚀 | **Browser**                |  [Firefox](https://www.mozilla.org/)                        |
  | 📂 | **File Manager**           |  [Thunar](https://wiki.archlinux.org/title/Thunar)          |
  | 🎨 | **Wallpaper Manager**      |  [Nitrogen](https://wiki.archlinux.org/title/Nitrogen)      |
  | 🍉 | **Colors**                 |  [Pywal](https://github.com/dylanaraps/pywal)               |

</div>


## Visuals
<table>
  <tr>
    <td><img src="assets/visual_nativo_morado.png" width="500" height="220"/></td>
    <td><img src="assets/visual_nativo_melon.png" width="500" height="220"/></td>
  </tr>
  <tr>
    <td><img src="assets/visual_vm_github.png" width="500" height=220"/></td>
    <td><img src="assets/visual_vm_neofetch.png" width="500" height="220"/></td>
  </tr>
</table>


## To Do's
- [x] Scratch my balls
- [ ] Terminate the automatic installer
- [ ] Adapt the dotfiles for all possible Debian based distros


## Credits
<div align="left">
  <table>
    <thead>
      <tr>
        <th>📂</th>
        <th>Users</th>
        <th>Inspirational repository</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>📝</td>
        <td><strong>@ZLCube</strong></td>
        <td><a href="https://github.com/ZLCube/KaliBspwm">https://github.com/ZLCube/KaliBspwm</a></td>
      </tr>
      <tr>
        <td>📝</td>
        <td><strong>@thespartoos</strong></td>
        <td><a href="https://github.com/thespartoos/deskBspwm">https://github.com/thespartoos/deskBspwm</a></td>
      </tr>
      <tr>
        <td>📝</td>
        <td><strong>@hidayry</strong></td>
        <td><a href="https://github.com/hidayry/dotfiles-bspwm">https://github.com/hidayry/dotfiles-bspwm</a></td>
      </tr>
    </tbody>
  </table>
</div>


