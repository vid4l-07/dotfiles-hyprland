#!/bin/bash

# Carpeta donde se guardarán los videos
VIDEO_DIR="$HOME/Videos"
mkdir -p "$VIDEO_DIR"

# Archivo temporal para guardar el PID de wf-recorder
PID_FILE="/tmp/wf-recorder.pid"

# Archivo de salida con fecha/hora
OUTPUT_FILE="$VIDEO_DIR/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"

if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
    # Si hay un PID activo, se detiene la grabación
    kill $(cat "$PID_FILE")
    rm "$PID_FILE"
    notify-send "Grabación detenida" "Archivo guardado en $OUTPUT_FILE"
else
    # Si no hay grabación activa, se inicia una nueva
    wf-recorder -f "$OUTPUT_FILE" &
    echo $! > "$PID_FILE"
    notify-send "Grabación iniciada"
fi
