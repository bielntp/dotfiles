#!/usr/bin/env python3

import json
from datetime import datetime

import requests

# OpenWeatherMap weather condition codes to emoji
WEATHER_ICONS = {
    "2": "",
    "3": "",
    "5": "",
    "6": "",
    "7": "",
    "800": "",
    "800n": "",
    "801": "",
    "801n": "",
    "802": "", 
    "802n": "",
    "803": "",
    "803n": "",
    "804": "",
}

API_KEY = "0435b5b7852e4d910cf9b5c2e66bd444"
CITY = "Florianópolis"
COUNTRY_CODE = "BR"
UNITS = "metric"

data = {}

try:
    current_url = f"https://api.openweathermap.org/data/2.5/weather?q={CITY},{COUNTRY_CODE}&appid={API_KEY}&units={UNITS}"
    current = requests.get(current_url, timeout=10).json()

    forecast_url = f"https://api.openweathermap.org/data/2.5/forecast?q={CITY},{COUNTRY_CODE}&appid={API_KEY}&units={UNITS}"
    forecast = requests.get(forecast_url, timeout=10).json()

    if current.get("cod") != 200:
        raise Exception(f"API Error: {current.get('message', 'Unknown error')}")

except Exception:
    data["text"] = " --°"
    data["tooltip"] = "Weather service unavailable"
    print(json.dumps(data))
    exit(0)


def get_weather_icon(weather_id, is_night=False):
    weather_str = str(weather_id)
    if is_night and weather_str + "n" in WEATHER_ICONS:
        return WEATHER_ICONS[weather_str + "n"]
    if weather_str in WEATHER_ICONS:
        return WEATHER_ICONS[weather_str]
    first_digit = weather_str[0]
    if first_digit in WEATHER_ICONS:
        return WEATHER_ICONS[first_digit]
    return ""


sunrise = current["sys"]["sunrise"]
sunset = current["sys"]["sunset"]
current_time = current["dt"]
is_night = current_time < sunrise or current_time > sunset

temp = round(current["main"]["temp"])
feels_like = round(current["main"]["feels_like"])
weather_id = current["weather"][0]["id"]
icon = get_weather_icon(weather_id, is_night)

data["text"] = f"{icon} {temp}°"

weather_desc = current["weather"][0]["description"].capitalize()
data["tooltip"] = f"<b>{weather_desc} {temp}°C</b>\n"
data["tooltip"] += f"Feels like: {feels_like}°C\n"
data["tooltip"] += f"Wind: {round(current['wind']['speed'] * 3.6)} km/h\n"
data["tooltip"] += f"Humidity: {current['main']['humidity']}%\n"
data["tooltip"] += f"Pressure: {current['main']['pressure']} hPa\n"

sunrise_time = datetime.fromtimestamp(sunrise).strftime("%H:%M")
sunset_time = datetime.fromtimestamp(sunset).strftime("%H:%M")
data["tooltip"] += f" {sunrise_time}AM   {sunset_time}PM\n"

if "list" in forecast:
    data["tooltip"] += "\n<b>Forecast:</b>\n"
    days_added = {}

    for item in forecast["list"][:16]:
        dt = datetime.fromtimestamp(item["dt"])
        day = dt.strftime("%a %d")
        time = dt.strftime("%H:%M")
        temp_f = round(item["main"]["temp"])
        desc = item["weather"][0]["description"]
        w_id = item["weather"][0]["id"]

        if day not in days_added:
            days_added[day] = []

        icon_f = get_weather_icon(w_id, dt.hour < 6 or dt.hour > 18)
        days_added[day].append(f"{time} {icon_f} {temp_f}° {desc}")

    for day, forecasts in list(days_added.items())[:3]:
        data["tooltip"] += f"\n<b>{day}</b>\n"
        data["tooltip"] += "\n".join(forecasts[:4]) + "\n"

print(json.dumps(data))
