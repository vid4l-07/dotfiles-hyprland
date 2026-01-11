#!/bin/bash

colors=$HOME/.config/hypr/scripts/colors.env
colors_all=$HOME/.config/hypr/scripts/colors.env-all

indicador=$(sed -n "1p" $colors)

if [[ $indicador == "#0-i" ]];then
	sed -n "/#1-i/,/#1-f/p" $colors_all > $colors
	echo "" > $HOME/.config/waybar/scripts/theme.txt
	theme="light"
else
	sed -n "/#0-i/,/#0-f/p" $colors_all > $colors
	echo "" > $HOME/.config/waybar/scripts/theme.txt
	theme="black"
fi

echo "$theme"


hyprwallpaper=$HOME/.config/hypr/hyprpaper.conf
kitty=$HOME/.config/kitty/color.ini
waybar=$HOME/.config/waybar/style.css
mako=$HOME/.config/mako/config
wofi=$HOME/.config/wofi/style.css
vim=$HOME/.config/nvim/colors/theme.vim

declare -A vimthemes
vimthemes[black]='smoke'
vimthemes[light]='smoke-light'


declare -A wallpapers
wallpapers[black]='$HOME/.config/wallpapers/1.jpeg'  #'$HOME/.config/wallpapers/8.jpg' #$HOME/.config/wallpapers/15.jpg
wallpapers[light]='$HOME/.config/wallpapers/11.jpg'

echo "colorscheme ${vimthemes[$theme]}" > $vim

(ls /run/user/1000/ | grep nvim) | while IFS= read -r sesion; do
	nvim --server /run/user/1000/$sesion --remote-send "<Cmd>silent! source \$MYVIMRC<CR>"  # Recarga todas las sesiones de nvim
done


echo -en "preload = ${wallpapers[$theme]} \nwallpaper = ,${wallpapers[$theme]} \nipc = on" > $hyprwallpaper
kill $(pgrep hyprpaper) 2>/dev/null
hyprpaper & > /dev/null

set -o allexport
source $colors
set +o allexport

for i in $kitty $waybar $mako $wofi; do
	envsubst < "$i.template" > "$i"
done

kill -SIGUSR1 $(pgrep kitty)

kill $(pgrep mako) 2>/dev/null
mako &

