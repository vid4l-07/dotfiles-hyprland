#!/bin/bash

ip_address=$(cat ${HOME}/.config/bin/target | awk '{print $1}')
machine_name=$(cat ${HOME}/.config/bin/target | awk '{print $2}')

if [ $ip_address ] && [ $machine_name ]; then
    echo "%{F#e51d0b}󰓾 %{F#ffffff}$ip_address%{u-} - $machine_name"
elif [ $ip_address ]; then
    echo "%{F#e51d0b}󰓾 %{F#ffffff}$ip_address%{u-}"
else
    echo " No target"
fi
