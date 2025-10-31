#!/bin/bash

ip=${HOME}/.config/bin/net/wlan-ip.sh
essid=${HOME}/.config/bin/net/wlan-essid.sh
script=${HOME}/.config/bin/net/net.sh
tun=${HOME}/.config/bin/net/tun-ip.sh

if [ "$1" == "1" ]; then
		if cmp -s $script $essid; then
				rm $script
				cp $ip $script
		elif cmp -s $script $ip; then
				rm $script
				cp $essid $script
		elif cmp -s $script $tun; then
				ip -4 addr show tun0 2> /dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | xclip -selection clipboard
		else
				echo "Error"
		fi
fi

if [ "$1" == "2" ]; then
		if cmp -s $script $tun; then
				rm $script
				cp $essid $script
		else
				rm $script
				cp $tun $script
		fi
fi





