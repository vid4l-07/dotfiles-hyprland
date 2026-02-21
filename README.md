# Hyprland Dotfiles

<div align="center">

My easy and minimal dotfiles for hyprland

Hope it can help 

<p style="color: #e4bd66;">
    ❗If something does not work, please 
<a href="https://github.com/Firstp1ck/Hyprland_simple-minimal_Setup/issues/new" rel="noopener noreferrer" style="color: rgb(123, 130, 255); text-decoration: underline;">open an issue</a>
 on this repository or E-Mail me via
<a href="mailto:h.vidal7@proton.me"> h.vidal7@proton.me </a>❗<br>
I am always open to suggestions and feedback
  </p>

<br>
  <a href="#Screenshots"><kbd> <br> Screenshots <br> </kbd></a>&ensp;&ensp;
  <a href="#Apps"><kbd> <br> Apps <br> </kbd></a>&ensp;&ensp;
  <a href="#Theme"><kbd> <br> Theme <br> </kbd></a>&ensp;&ensp;
  <a href="#Installation"><kbd> <br> Installation <br> <br></kbd></a>&ensp;&ensp;

</div>

---

## Screenshots

<div align="center">

https://github.com/user-attachments/assets/5441a8aa-1b3b-45ae-b679-7fc5474403a5

</div>

## Apps
|Component|Resource| 
|:---------|:-----|
|WM| Hyprland|
|Bar| waybar|
|Launcher| wofi|
| Terminal| kitty|
| Notifications| mako|
| Shell| fish|
| Fetch| fastfetch|
| Theme| smoke (made by me)|

---

## Theme

- **Smoke dark**

<img src=".github/colores-dark.png" width="400">

- **Smoke light**

<img src=".github/colores-light.png" width="400">

- Color file: ```config/hypr/scripts/colors.env-all```
- Vim theme: ```config/nvim/colors/smoke*.vim```

---

## Installation
1. Create backups
```bash
cp -r $HOME/.config $HOME/config-back
```

2. Clone the repository
```bash
git clone https://github.com/vid4l-07/dotfiles-hyprland.git
cd dotfiles
```

3. Copy the dotfiles
```bash
mv config/* wallpapers $HOME/.config
```

