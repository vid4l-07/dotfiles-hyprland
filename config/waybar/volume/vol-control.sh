#!/bin/bash

show(){
	if [[ -z  $(pgrep -a waybar | grep volume | awk '{print $1}') ]];then
		waybar -c /home/hvidal/.config/waybar/volume/config-volume.jsonc -s /home/hvidal/.config/waybar/volume/style-volume.css &
	fi
}

INTERACTION="/home/hvidal/.config/waybar/volume/interaction.txt"
LOCKFILE="/tmp/vol.lock"

if ! [ -e $LOCKFILE ];then  # Esto es por si se ejecuta dos veces. Con este if solo se ejecuta una vez por pulsacion.
	touch $LOCKFILE
	case $1 in
		"up")
			wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
			date +%s > $INTERACTION
			show
		;;
		"down")
			wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-
			date +%s > $INTERACTION
			show
		;;
		"mute")
			wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
			date +%s > $INTERACTION
			show
		;;
	esac
	rm $LOCKFILE
fi

