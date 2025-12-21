#!/bin/bash

show(){
	if [[ -z  $(pgrep -a waybar | grep volume | awk '{print $1}') ]];then
		waybar -c /home/hvidal/.config/waybar/volume/config-volume.jsonc -s /home/hvidal/.config/waybar/volume/style-volume.css &
	fi
}

interaction="/home/hvidal/.config/waybar/volume/interaction.txt"

case $1 in
	"up")
		wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
		date +%s > $interaction
		show
	;;
	"down")
		wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
		date +%s > $interaction
		show
	;;
	"mute")
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
		date +%s > $interaction
		show
	;;
esac

