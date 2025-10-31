#!/bin/bash

redwlan0=$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

redwlan1=$(ip -4 addr show wlan1 2> /dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [ "$redwlan0" == "" ]; then
	redwlan0="Not connected"
fi

if [ "$redwlan1" == "" ]; then
	redwlan1="Not connected"
fi

if ip -4 addr show wlan1 > /dev/null 2>&1; then
	echo " $redwlan0 / $redwlan1"
else
	echo " $redwlan0"
fi
