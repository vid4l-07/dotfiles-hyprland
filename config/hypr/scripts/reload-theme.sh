#!/bin/bash

#themes: black, catapuccin

theme=$1
colors=$HOME/.config/hypr/scripts/colors.env

sed -n "/${theme}-theme-inicio/,/${theme}-theme-fin/p" $colors-all > $colors

kitty=$HOME/.config/kitty/color.ini
waybar=$HOME/.config/waybar/style.css
mako=$HOME/.config/mako/config
wofi=$HOME/.config/wofi/style.css

set -o allexport
source $colors
set +o allexport

for i in $kitty $waybar $mako $wofi; do
		envsubst < "$i.template" > "$i"
done
kill $(pgrep mako) 2>/dev/null
mako &

