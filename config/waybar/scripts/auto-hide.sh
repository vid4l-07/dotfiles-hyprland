#!/bin/bash

WAYBAR_HEIGHT=32     # Ajusta si tu waybar es más alta
CHECK_INTERVAL=0.2   # Frecuencia de chequeo del ratón
HIDE_AFTER=7        # Segundos sin tocar la barra para ocultarla

last_interaction=$(date +%s)

toggle_waybar() {
	kill $(pgrep -a waybar | grep top | awk '{print $1}')
}

while true; do
    # Posición actual del cursor
	y=$(hyprctl -j cursorpos | grep y | awk '{print $2}')
    now=$(date +%s)

    # Si el cursor está en el borde superior -> mostrar la barra
    if [ "$y" -le "$WAYBAR_HEIGHT" ]; then
        last_interaction=$now
    else
        # Si no hay interacción por 10s -> ocultar
        if [ $((now - last_interaction)) -ge $HIDE_AFTER ]; then
            toggle_waybar
        fi
    fi

    sleep $CHECK_INTERVAL
done
