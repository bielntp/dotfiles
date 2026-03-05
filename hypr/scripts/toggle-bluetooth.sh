#!/usr/bin/env bash

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    bluetoothctl power on
    notify-send "Bluetooth" "Ativado"
else
    rfkill block bluetooth
    notify-send "Bluetooth" "Desativado"
fi
