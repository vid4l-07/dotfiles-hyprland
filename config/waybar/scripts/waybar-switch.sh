#!/bin/bash

if [ $1 == '-top' ];then
		kill $(pgrep -a waybar | grep top | awk '{print $1}') || waybar -c $HOME/.config/waybar/config-top.jsonc -s /home/hvidal/.config/waybar/style.css
elif [ $1 == '-right' ];then
		kill $(pgrep -a waybar | grep right | awk '{print $1}') || waybar -c $HOME/.config/waybar/right-bar/config-right.json -s /home/hvidal/.config/waybar/style.css
fi
# proceso=$(pgrep waybar)
#
# if kill $proceso 2> /dev/null; then
# 		kill $proceso > /dev/null
# else
# 		waybar
# fi
