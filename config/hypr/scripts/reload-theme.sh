#!/bin/bash

#themes: black, catapuccin

theme=$1
colors=$HOME/.config/hypr/scripts/colors.env

sed -n "/${theme}-theme-inicio/,/${theme}-theme-fin/p" $colors-all > $colors

kitty=$HOME/.config/kitty/color.ini
waybar=$HOME/.config/waybar/style.css


set -o allexport
source $colors
set +o allexport

for i in $kitty $waybar; do
		envsubst < "$i.template" > "$i"
done
