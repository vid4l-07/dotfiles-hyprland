#!/bin/bash

len=$(setxkbmap -query | grep layout | awk '{print $2}')

if [ $len == "us" ]; then
		setxkbmap es
elif [ $len == "es" ]; then
		setxkbmap us
fi

