# Hyprland Dotfiles

Mi configuracion de Hyprland — minimalista, rápida y altamente personalizable.

---

## Screenshots

<div align="center">

https://github.com/user-attachments/assets/6d3a99f4-51a7-44c4-9789-1adc3a56ceca

</div>

## Información
- WM: Hyprland
- Bar: waybar
- Launcher: wofi
- Terminal: kitty
- Notificaciones: mako
- Shell: fish
- Tema: smoke (hecho por mi)

---

## Tema

- **Smoke dark**

<img src=".github/colores-dark.png" width="400">

- **Smoke light**

<img src=".github/colores-light.png" width="400">

- Archivo de colores en ```config/hypr/scripts/colors.env-all```

---

## Instalación
1. Crear backups
```bash
cp -r $HOME/.config $HOME/config-back
```

2. Clonar el repositorio
```bash
git clone https://github.com/usuario/dotfiles.git
cd dotfiles
```

3. Copiar la configuracion
```bash
mv config/* wallpapers $HOME/.config
```
