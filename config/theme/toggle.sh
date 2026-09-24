#!/bin/bash

# Paths
script_path="$HOME/.config/theme"

current_file="$script_path/current_theme"

hyprwallpaper="$HOME/.config/hypr/hyprpaper.conf"
kitty="$HOME/.config/kitty/color.ini"
waybar="$HOME/.config/waybar/style.css"
waybar_icon="$HOME/.config/waybar/scripts/theme.txt"
mako="$HOME/.config/mako/config"
vim="$HOME/.config/nvim/colors/theme.vim"

# Theme
current=$(<"$current_file")

if [[ $current == "dark" ]];then
	theme="light"
else
	theme="dark"
fi

echo "$theme" > "$current_file"
colors="$script_path/$theme.env"

# Configs

set -o allexport
source "$colors"
set +o allexport

declare -A icons
icons[dark]=""
icons[light]=""

declare -A wallpapers
wallpapers[dark]="$HOME/.config/wallpapers/1.jpeg"
wallpapers[light]="$HOME/.config/wallpapers/11.jpg"

declare -A vimthemes
vimthemes[dark]="smoke"
vimthemes[light]="smoke-light"

echo "${icons[$theme]}" > "$waybar_icon"


# Hyprpaper
cat > "$hyprwallpaper" <<EOF
preload = ${wallpapers[$theme]}
wallpaper = ,${wallpapers[$theme]}
ipc = on
EOF

hyprctl hyprpaper reload ",${wallpapers[$theme]}"

# Neovim
echo "colorscheme ${vimthemes[$theme]}" > "$vim"

for sesion in /run/user/$(id -u)/nvim.*; do
    [ -e "$sesion" ] || continue
    nvim --server "$sesion" --remote-send '<Cmd>silent! source $MYVIMRC<CR>'
done

# Generate config files
for i in "$kitty" "$waybar" "$mako"; do
	envsubst < "$i.template" > "$i"
done

# Reload applications
pkill -SIGUSR1 kitty 2>/dev/null

pkill mako 2>/dev/null
mako &

