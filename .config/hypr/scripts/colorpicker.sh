#!/bin/bash

iDIR="$HOME/.config/swaync/icons"

COLOR=$(hyprpicker)

notify-send "Cor copiada" "$COLOR" -i $iDIR/palette.png

echo -n "$COLOR" | wl-copy
