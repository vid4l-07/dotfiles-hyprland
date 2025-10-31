#!/bin/bash

touch /tmp/url-album.txt
# Obtiene información de la canción actual de Spotify via D-Bus
ALBUM_ART_URL=$(dbus-send \
    --print-reply \
    --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"Metadata" \
    | grep -A 1 "mpris:artUrl" \
    | tail -n 1 \
    | awk -F'"' '{print $2}')

if [ "$ALBUM_ART_URL" != "$(/bin/cat /tmp/url-album.txt)" ];then
	echo $ALBUM_ART_URL > /tmp/url-album.txt

	if [ -z "$ALBUM_ART_URL" ]; then
		echo " "
		rm $HOME/.config/waybar/right-bar/image.jpg 2>/dev/null
		exit 1
	fi

	# Descarga temporal de la imagen
	wget -q "$ALBUM_ART_URL" -O $HOME/.config/waybar/right-bar/image.jpg
fi
