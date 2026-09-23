#!/bin/bash

FOLDER="$HOME/Screenshots"
FILE="$FOLDER/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"

mkdir -p $FOLDER

grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE"
