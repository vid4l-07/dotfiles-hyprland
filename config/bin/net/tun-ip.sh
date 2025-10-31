#!/bin/bash

tunip=$(ip -4 addr show tun0 2> /dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')


if ip -4 addr show tun0 > /dev/null 2>&1; then
	echo "󰖂 $tunip"
else
	echo "󰖂 Not connected"
fi
