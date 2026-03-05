#!/usr/bin/env bash

pkill waybar
pkill swaync
sleep 0.1
waybar &
swaync &
