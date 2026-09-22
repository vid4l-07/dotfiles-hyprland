<div align="center">

# Hyprland Dotfiles

Minimal, fast and easy-to-customize dotfiles for **Hyprland**, built around the **Smoke** theme (dark & light).

<br>

  <a href="#Features"><kbd> <br> Features <br> </kbd></a>&ensp;&ensp;
  <a href="#Stack"><kbd> <br> Stack <br> </kbd></a>&ensp;&ensp;
  <a href="#Theme"><kbd> <br> Theme <br> </kbd></a>&ensp;&ensp;
  <a href="#Requirements"><kbd> <br> Requirements <br> </kbd></a>&ensp;&ensp;
  <a href="#Installation"><kbd> <br> Installation <br> </kbd></a>&ensp;&ensp;

</div>

<br>

<div align="center">

https://github.com/user-attachments/assets/5441a8aa-1b3b-45ae-b679-7fc5474403a5

</div>

<br>

## Features

- **Smoke theme (dark/light)** — switch from the bar with a single click. `toggle-theme.sh` regenerates the `kitty`, `waybar` and `mako` configs on the fly and reloads open `nvim` sessions.
- **Terminal app searcher** — `SUPER + D` opens a floating TUI (`search_app.py`) that lists `.desktop` entries and binaries.
- **TUI powermenu** — `SUPER + Q` opens a centered powermenu with **lock · logout · reboot · shutdown**.
- **Music / Spotify bar** — a side bar with live album art, prev / pause / next controls and click-to-launch Spotify.
- **Switchable bars** — your waybar can be toggled between top and right layouts at runtime (`waybar-switch.sh`).
- **Screen recording** — toggle recording with `SUPER + ALT + R` (`rec.sh`, backed by `wf-recorder`), saved to `~/Videos`.
- **Screenshots** — fullscreen (`grim`) or region (`grim -g "$(slurp)"`).
- **Bluetooth TUI** — `bluetui` is wired into the bar and runs inside a floating kitty window.
- **Keyboard efficiency** — US/ES layouts toggled with `WIN + Space`, and Caps Lock swapped with Esc.

<br>

## Stack

| Component       | Resource                                                             |
|:----------------|:---------------------------------------------------------------------|
| Window Manager  | [Hyprland](https://hyprland.org)                                     |
| Status bar      | [waybar](https://github.com/Alexays/Waybar) (top + right music bar)  |
| Terminal        | [kitty](https://sw.kovidgoyal.net/kitty/)                            |
| Shell           | [zsh](https://www.zsh.org)                                           |
| Editor          | [neovim](https://neovim.io)                                          |
| App launcher    | Custom TUI (`config/bin/search_app.py`)                              |
| Powermenu       | Custom TUI (`config/bin/powermenu.py`)                               |
| Notifications   | [mako](https://github.com/emersion/mako)                             |
| Lockscreen      | [hyprlock](https://github.com/hyprwm/hyprlock)                       |
| Wallpaper       | [hyprpaper](https://github.com/hyprwm/hyprpaper)                     |
| System fetch    | [fastfetch](https://github.com/fastfetch-cli/fastfetch)              |
| Theme           | **Smoke** (dark/light, made by me)                                   |

<br>

## Theme

**Smoke** comes in two variants and is fully driven by a color source file, so the palette is kept in sync across every component.

- `config/hypr/scripts/colors.env-all`: master color source
- `config/hypr/scripts/toggle-theme.sh`: the toggle script (bound to the bar icon)
- `config/nvim/colors/smoke*.vim`: Neovim colorschemes

**Smoke dark**

<img src=".github/colores-dark.png" width="400">

**Smoke light**

<img src=".github/colores-light.png" width="400">

<br>

## Requirements

Core:

- `hyprland`, `hyprlock`, `hyprpaper`
- `waybar` (built with `gtk-layer-shell`)
- `kitty`, `mako`, `zsh`, `neovim`
- `python3`

Utilities (used by the scripts):

- `grim`, `slurp` — screenshots
- `wf-recorder` — screen recording
- `playerctl` — media keys / Spotify bar
- `brightnessctl` — backlight control
- `wireplumber` (`wpctl`) — volume control
- `wl-clipboard` (`wl-copy`) — clipboard interactions
- [`bluetui`](https://github.com/pythops/bluetuith) — Bluetooth TUI (bundled binary in `config/waybar/scripts/`)
- A [Nerd Font](https://www.nerdfonts.com) — a bundle is included in `config/fonts/`

<br>

## Installation

### 1. Backup your current config

```bash
cp -r $HOME/.config $HOME/config-back
```

### 2. Clone the repository

```bash
git clone https://github.com/vid4l-07/dotfiles-hyprland.git
cd dotfiles-hyprland
```

### 3. Copy the dotfiles

```bash
cp -r config/* wallpapers $HOME/.config
```

### 4. Install the fonts (optional)

```bash
mkdir -p $HOME/.local/share/fonts
unzip -o "config/fonts/*.zip" -d $HOME/.local/share/fonts
fc-cache -fv
```

### 5. Restart

Re-login (or restart Hyprland) to pick up all changes.

> [!Note]
> `hyprland.conf` assumes a monitor named `HDMI-A-1`, placed to the `auto-right` of the primary. Adjust the `monitor=` line to match your setup.
