#!/bin/bash

redwlan0=$(iw dev wlan0 link | grep SSID | awk '{print substr($0, index($0,$2))}')

redwlan1=$(iw dev wlan1 link 2> /dev/null | grep SSID | awk '{print substr($0, index($0,$2))}')

if [ "$redwlan0" == "" ]; then
	redwlan0="Not connected"
fi

if [ "$redwlan1" == "" ]; then
	redwlan1="Not connected"
fi

if iw dev wlan1 link > /dev/null 2> /dev/null; then
	echo " $redwlan0 / $redwlan1"
else
	echo " $redwlan0"
fi
