#!/bin/bash

options=('black' 'catapuccin' 'nordic')

if [[ "$1" == "--help" || -z "$1" ]];then
	echo -e "Usage: reload-theme [index]\n"
	num=0
	for i in "${options[@]}";do
		echo "$i --> $num"
		((num++))
	done
fi

theme="${options[$1]}"
colors=$HOME/.config/hypr/scripts/colors.env

correcto=false
for i in "${options[@]}";do
	if [[ "$theme" == "$i" ]];then
		correcto=true
	fi
done

if ! $correcto;then
	echo 'No existe'
	exit 1
fi

echo "$theme"

sed -n "/${theme}-theme-inicio/,/${theme}-theme-fin/p" $colors-all > $colors

hyprwallpaper=$HOME/.config/hypr/hyprpaper.conf
kitty=$HOME/.config/kitty/color.ini
waybar=$HOME/.config/waybar/style.css
mako=$HOME/.config/mako/config
wofi=$HOME/.config/wofi/style.css
vim=$HOME/.config/nvim/theme.vim

declare -A vimthemes
vimthemes[black]='smoke'
vimthemes[catapuccin]='catppuccin'
vimthemes[nordic]='nordic'

declare -A wallpapers
wallpapers[black]='$HOME/.config/wallpapers/8.jpg' #$HOME/.config/wallpapers/15.jpg
wallpapers[catapuccin]='$HOME/.config/wallpapers/14.jpg'
wallpapers[nordic]='$HOME/.config/wallpapers/2.jpg'

echo "colorscheme ${vimthemes[$theme]}" > $vim
echo -en "preload = ${wallpapers[$theme]} \nwallpaper = ,${wallpapers[$theme]} \nipc = on" > $hyprwallpaper
kill $(pgrep hyprpaper) 2>/dev/null
hyprpaper & > /dev/null

if [ $theme == 'black' ];then
	echo -e '
hi! link @variable Text
hi! link BlinkCmpScrollBarThumb Normal
hi! link BlinkCmpScrollBarGutter Normal

hi! link BlinkCmpMenuSelection Search

hi! link BlinkCmpDoc Pmenu
hi! link BlinkCmpDocBorder Pmenu
hi! link BlinkCmpDocSeparator Pmenu
hi! link BlinkCmpDocCursorLine Pmenu

hi! link StatusLine Normal
hi! link StatusLineNC Normal
hi! link LualineInsertA LualineVisualA
hi! link LualineInsertB LualineVisualB

hi! link BufferLineTab Normal
hi! link BufferLineFill BufferLineInfo


hi! link NormalFloat Pmenu' >> $vim
fi

set -o allexport
source $colors
set +o allexport

for i in $kitty $waybar $mako $wofi; do
		envsubst < "$i.template" > "$i"
done
kill $(pgrep mako) 2>/dev/null
mako &

