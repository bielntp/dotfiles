#!/bin/bash

iDIR="$HOME/.config/swaync/icons"
icon="$iDIR/picture.png"

SAVE_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVE_DIR"

notify_user() {
	notify-send -e \
	-h string:x-canonical-private-synchronous:screenshot_notif \
	-u low \
	-i "$icon" \
	"Screenshot" "Screenshot taken"
}

take_screenshot() {
	FILE="$SAVE_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

	if grimblast --freeze copysave area "$FILE"; then
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
