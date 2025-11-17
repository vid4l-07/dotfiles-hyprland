#!/bin/bash

WAYBAR_HEIGHT=32     # Ajusta si tu waybar es más alta
CHECK_INTERVAL=0.2   # Frecuencia de chequeo del ratón
HIDE_AFTER=5        # Segundos sin tocar la barra para ocultarla

last_interaction=$(date +%s)
visible=1  # 1 = visible, 0 = oculto

toggle_waybar() {
	kill $(pgrep -a waybar | grep top | awk '{print $1}') || waybar -c $HOME/.config/waybar/config-top.jsonc -s /home/hvidal/.config/waybar/style.css &
}

while true; do
    # Posición actual del cursor
	y=$(hyprctl -j cursorpos | grep y | awk '{print $2}')
    now=$(date +%s)

    # Si el cursor está en el borde superior -> mostrar la barra
    if [ "$y" -le "$WAYBAR_HEIGHT" ]; then
		echo 'ahora'
        last_interaction=$now
        if [ $visible -eq 0 ]; then
            toggle_waybar
            visible=1
        fi
    else
        # Si no hay interacción por 10s -> ocultar
        if [ $visible -eq 1 ] && [ $((now - last_interaction)) -ge $HIDE_AFTER ]; then
            toggle_waybar
            visible=0
        fi
    fi

    sleep $CHECK_INTERVAL
done
