#!/bin/bash

if [ -z spotify ]; then
    exit 0
fi

status=$(playerctl --player=spotify status 2>/dev/null)

if [ "$status" != "Playing" ]; then
    exit 0
fi

song_info=$(playerctl --player=spotify metadata --format '{{title}}       {{artist}}' 2>/dev/null)

echo "$song_info"
