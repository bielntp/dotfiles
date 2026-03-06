#!/bin/bash

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000

# Get brightness
get_backlight() {
	brightnessctl -m | cut -d, -f4 | sed 's/%//'
}

# Get icons
get_icon() {
	current=$(get_backlight)
	if   [ "$current" -le "20" ]; then
		icon="$iDIR/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$iDIR/brightness-40.png"
	elif [ "$current" -le "60" ]; then
		icon="$iDIR/brightness-60.png"
	elif [ "$current" -le "80" ]; then
		icon="$iDIR/brightness-80.png"
	else
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify (mesmo padrão do teu script)
notify_user() {
	notify-send -e \
	-h string:x-canonical-private-synchronous:brightness_notif \
	-h int:value:$current \
	-u low \
	-i "$icon" \
	"Screen" "Brightness:$current%"
}

# ---- FORÇAR 100% ----

current=$(get_backlight)

if [ "$current" -lt 100 ]; then
	brightnessctl set 100%
	current=100
	get_icon
	notify_user
fi
