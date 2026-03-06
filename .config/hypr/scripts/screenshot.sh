#!/bin/bash

iDIR="$HOME/.config/swaync/icons"
icon="$iDIR/picture.png"

notify_user() {
	notify-send -e \
	-h string:x-canonical-private-synchronous:screenshot_notif \
	-u low \
	-i "$icon" \
	"Screenshot" "Screenshot taken"
}

take_screenshot() {
	if grim -g "$(slurp)" - | wl-copy; then
		notify_user
	fi
}

case "$1" in
	"--area")
		take_screenshot
		;;
	*)
		take_screenshot
		;;
esac
