<div align="center">
  <img src="https://img.shields.io/github/last-commit/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=b4befe" alt="GitHub last commit">
  <img src="https://img.shields.io/github/repo-size/edgar-ramxs/dotfiles-bspwm?style=for-the-badge&color=cba6f7" alt="GitHub repo size">
</div>


# Introduction
🙋‍♂️ Hi, I've created this installation process automation using a `tiling window manager`, in this case `bspwm` preferably, to customize a minimalist Debian system environment from scratch.

⛳ Initially, I decided to create these dotfiles for use in minimal environments of Debian-based distributions such as Kali Linux, Parrot, Ubuntu, and others. 🫰 However, I am going to prepare the setup and automatic installation for other popular distributions such as Arch, Fedora, etc.


- 🧑‍💻 These dotfiles have been tested on the following distributions:
  + [Debian](https://www.debian.org/)
  + [Kali Linux](https://www.kali.org/)


## Pre-installation

```bash
# repository organization
.
├── installer.sh
├── README.md
├── assets          # photos, documents, etc. to view the environment
├── bin             # binaries or scripts for use within the environment
├── config          # Configuring applications, managers and tools
├── home            # Shell configuration and others
├── packages        # List of packages to be installed
├── scripts         # scripts to install or update tools
└── wallpapers      # wallpapers for the environment
```
There are automated scripts to install, configure and download some tools for the custom environment inside the `scripts/` directory. 📭 For example, there is a script called `debian_testing.sh` that upgrades to the debian testing branch, where it can be used at the beginning or end of the automated installation, if you want to switch to the testing branch.


## Installation
```bash
sudo apt install -y git vim neofetch # or fastfetch

git clone https://github.com/edgar-ramxs/dotfiles-bspwm.git ~/dotfiles-bspwm

cd ~/dotfiles-bspwm

chmod +x installer.sh

./installer.sh -s [bash|zsh] -r [1920x1080|1366x768]
```


## Post-installation
Read the [KEYBINDING.md](assets/KEYBINDING.md) to find out what the keyboard shortcuts are that were configured by me.


## Details
<div align="center">

  |     | Component                 | Package                                                     |
  | --- | ------------------------- | ----------------------------------------------------------- |
  | 💻 | **Window Manager**         |  [bspwm](https://github.com/baskerville/bspwm)              |
  | 🐱 | **Terminal**               |  [kitty](https://sw.kovidgoyal.net/kitty/)                  |
  | 🦊 | **Shell**                  |  [zsh](https://ohmyz.sh/)                                   |
  | 🎼 | **Compositor**             |  [picom](https://github.com/yshui/picom)                    |
  | 💈 | **Bar**                    |  [polybar](https://github.com/polybar/polybar)              |
  | 🔍 | **Menu Launcher**          |  [rofi](https://github.com/davatorium/rofi)                 |
  | 🔔 | **Notify Daemon**          |  [dunst](https://github.com/dunst-project/dunst)            |
  | 📝 | **Editor**                 |  [visual studio code](https://code.visualstudio.com/)       |
  | 🚀 | **Browser**                |  [firefox](https://www.mozilla.org/)                        |
  | 📂 | **File Manager**           |  [thunar](https://wiki.archlinux.org/title/Thunar)          |
  | 🎨 | **Wallpaper Manager**      |  [nitrogen](https://wiki.archlinux.org/title/Nitrogen)      |
  | 🍉 | **Colors**                 |  [pywal](https://github.com/dylanaraps/pywal)               |

</div>

| Visuals |
|:-:|
| <img src="assets/a1.png"/> |
| <img src="assets/a2.png"/> |
| <img src="assets/a3.png"/> |


## To Do's
- [x] Scratch my balls
- [ ] Terminate the automatic installer
- [ ] Adapt the dotfiles for all possible Debian based distros


## Credits
<div align="left">
  <table>
    <thead>
      <tr>
        <th>Users</th>
        <th>Repositories</th>
        <th>Referenced</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>😎 @drewgrif</strong></td>
        <td><a href="https://github.com/drewgrif/bookworm-scripts">📝 Link</a></td>
        <td>📦 all in one</td>
      </tr>
      <tr>
        <td><strong>😎 @ZLCube</strong></td>
        <td><a href="https://github.com/ZLCube/KaliBspwm">📝 Link</a></td>
        <td>📦 design, auto-installer, bspwm config, ethical hacking.</td>
      </tr>
      <tr>
        <td><strong>😎 @thegoodhackertv</strong></td>
        <td><a href="https://github.com/thegoodhackertv/hackerpwm">📝 Link</a></td>
        <td>📦 auto-installer, bspwm config, ethical hacking.</td>
      </tr>
      <tr>
        <td><strong>😎 @AlvinPix</strong></td>
        <td><a href="https://github.com/AlvinPix/bspwm">📝 Link</a></td>
        <td>📦 auto-installer, bspwm config, ethical hacking.</td>
      </tr>
      <tr>
        <td><strong>😎 @RoccoRakete</strong></td>
        <td><a href="https://github.com/RoccoRakete/bspwm-gruvbox">📝 Link</a></td>
        <td>📦 polybar, auto-installer, bspwm config.</td>
      </tr>
      <tr>
        <td><strong>😎 @pznguin-kyun</strong></td>
        <td><a href="https://github.com/pznguin-kyun/pengurice">📝 Link</a></td>
        <td>📦 auto-installer, bspwm config.</td>
      </tr>
      <tr>
        <td><strong>😎 @zoddDev</strong></td>
        <td><a href="https://github.com/zoddDev/dotfiles">📝 Link</a></td>
        <td>📦 design, polybar, auto-installer, bspwm config, packages.</td>
      </tr>
      <tr>
        <td><strong>😎 @moonlight-coffee</strong></td>
        <td><a href="https://github.com/moonlight-coffee/happypinky">📝 Link</a></td>
        <td>📦 bspwm config, polybar, scripts.</td>
      </tr>
      <tr>
        <td><strong>😎 @Ghost1nTh3SSH</strong></td>
        <td><a href="https://github.com/Ghost1nTh3SSH/dotfiles">📝 Link</a></td>
        <td>📦 polybar, auto-installer, bspwm config.</td>
      </tr>
      <tr>
        <td><strong>😎 @ohxxm</strong></td>
        <td><a href="https://github.com/ohxxm/dotfiles">📝 Link</a></td>
        <td>📦 picom, polybar, bspwm config, widgets, debian.</td>
      </tr>
      <tr>
        <td><strong>😎 @Prayag2</strong></td>
        <td><a href="https://github.com/Prayag2/dotfiles">📝 Link</a></td>
        <td>📦 themes, design, bspwm config, polybar, lxsession, config themes.</td>
      </tr>
      <tr>
        <td><strong>😎 @sebasruiz09</strong></td>
        <td><a href="https://github.com/sebasruiz09/Arch-BSPWM">📝 Link</a></td>
        <td>📦 auto-install, bspwm config, polybar, conky.</td>
      </tr>
      <tr>
        <td><strong>😎 @MarioRRom</strong></td>
        <td><a href="https://github.com/MarioRRom/bspwm-dotfiles">📝 Link</a></td>
        <td>📦 auto-installer, polybar, bspwm config, widgets.</td>
      </tr>
      <tr>
        <td><strong>😎 @Battlesquid</strong></td>
        <td><a href="https://github.com/Battlesquid/dotfiles">📝 Link</a></td>
        <td>📦 auto-installer, polybar, bspwm config, widgets, betterlockscreen.</td>
      </tr>
      <tr>
        <td><strong>😎 @ayamir</strong></td>
        <td><a href="https://github.com/ayamir/bspwm-dotfiles">📝 Link</a></td>
        <td>📦 design, themes, polybar, bspwm config.</td>
      </tr>
      <tr>
        <td><strong>😎 @gh0stzk</strong></td>
        <td><a href="https://github.com/gh0stzk/dotfiles">📝 Link</a></td>
        <td>📦 themes, design, auto-installer, bspwm config.</td>
      </tr>
    </tbody>
  </table>
</div>



<!-- Another dotfiles for bspwm

https://github.com/drewgrif/debian-installers
https://github.com/drewgrif/bookworm-scripts
https://github.com/justleoo/dotfiles -> bspwm config
https://github.com/mmsaeed509/bspwm-dots
https://github.com/aadityasinha-dotcom/dotfile -> configs
https://github.com/K4rlosReyes/arch-bspwm -> arch install guide, bspwm config
https://github.com/radstevee/dotfiles -> bspwm config
https://github.com/nameCh3ll/rice
https://github.com/saimoomedits/bspwm-first-rice -> bspwm config
https://github.com/DominatorXS/LinuxDotz -> bspwm config
https://github.com/ChrisTitusTech/Debian-titus -> auto-installer, debian.
https://github.com/lostalejandro/bspwm -> auto-installer, debian, bspwm config.
https://github.com/Alien-Tec/debian-dotfiles -> auto-installer, bspwm config.
https://github.com/hidayry/dotfiles-bspwm -> bspwm config, debian. 

-->
