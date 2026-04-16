#!/usr/bin/env python3
"""Simple weather checker using wttr.in and Open-Meteo APIs."""

import sys
import argparse
import urllib.request
import urllib.parse
import json
from datetime import datetime


def get_weather_wttr(location):
    """Get weather from wttr.in (no API key required)."""
    try:
        encoded_location = urllib.parse.quote(location)
        url = f"https://wttr.in/{encoded_location}?format=j1"

        req = urllib.request.Request(url, headers={"User-Agent": "curl/7.68.0"})
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode("utf-8"))
            return data
    except Exception as e:
        print(f"Error fetching weather: {e}")
        return None


def get_weather_openmeteo(lat, lon, location_name):
    """Get weather from Open-Meteo (no API key required)."""
    try:
        url = (
            f"https://api.open-meteo.com/v1/forecast?"
            f"latitude={lat}&longitude={lon}"
            f"&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m"
            f"&daily=temperature_2m_max,temperature_2m_min"
            f"&timezone=auto"
        )

        req = urllib.request.Request(url)
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode("utf-8"))
            data["location_name"] = location_name
            return data
    except Exception as e:
        print(f"Error fetching weather: {e}")
        return None


def format_weather_wttr(data, location, unit='c'):
    """Format wttr.in weather data for display."""
    if not data:
        return "Could not fetch weather data."

    current = data["current_condition"][0]
    weather_desc = current["weatherDesc"][0]["value"]
    temp_c = current["temp_C"]
    temp_f = current["temp_F"]
    humidity = current["humidity"]
    wind_kmph = current["windspeedKmph"]

    output = []
    output.append(f"\n🌍 Weather for: {location}")
    output.append("-" * 40)

    if unit == 'f':
        output.append(f"🌡️  Temperature: {temp_f}°F")
    elif unit == 'b':
        output.append(f"🌡️  Temperature: {temp_c}°C / {temp_f}°F")
    else:
        output.append(f"🌡️  Temperature: {temp_c}°C")

    output.append(f"☁️  Condition: {weather_desc}")
    output.append(f"💧 Humidity: {humidity}%")
    output.append(f"💨 Wind: {wind_kmph} km/h")
    output.append("-" * 40)

    # Forecast
    output.append("\n📅 3-Day Forecast:")
    for day in data["weather"][:3]:
        date = day["date"]
        if unit == 'f':
            max_temp = day["maxtempF"]
            min_temp = day["mintempF"]
            unit_label = "°F"
        else:
            max_temp = day["maxtempC"]
            min_temp = day["mintempC"]
            unit_label = "°C"
        desc = day["hourly"][4]["weatherDesc"][0]["value"]
        output.append(f"  {date}: {min_temp}{unit_label} - {max_temp}{unit_label}, {desc}")

    return "\n".join(output)


def format_weather_openmeteo(data, unit='c'):
    """Format Open-Meteo weather data for display."""
    if not data:
        return "Could not fetch weather data."

    current = data["current"]
    location = data.get("location_name", "Unknown Location")

    # WMO Weather interpretation codes
    weather_codes = {
        0: "Clear sky",
        1: "Mainly clear", 2: "Partly cloudy", 3: "Overcast",
        45: "Foggy", 48: "Depositing rime fog",
        51: "Light drizzle", 53: "Moderate drizzle", 55: "Dense drizzle",
        61: "Slight rain", 63: "Moderate rain", 65: "Heavy rain",
        71: "Slight snow", 73: "Moderate snow", 75: "Heavy snow",
        77: "Snow grains",
        80: "Slight rain showers", 81: "Moderate rain showers", 82: "Violent rain showers",
        85: "Slight snow showers", 86: "Heavy snow showers",
        95: "Thunderstorm", 96: "Thunderstorm with slight hail", 99: "Thunderstorm with heavy hail"
    }

    weather_desc = weather_codes.get(current["weather_code"], "Unknown")
    temp = current["temperature_2m"]
    humidity = current["relative_humidity_2m"]
    wind = current["wind_speed_10m"]

    # Convert to Fahrenheit if needed
    if unit == 'f':
        temp = temp * 9/5 + 32
        unit_label = "°F"
    elif unit == 'b':
        temp_f = temp * 9/5 + 32
        unit_label = f"°C / {temp_f:.1f}°F"
    else:
        unit_label = "°C"

    output = []
    output.append(f"\n🌍 Weather for: {location}")
    output.append("-" * 40)
    output.append(f"🌡️  Temperature: {temp}{unit_label}")
    output.append(f"☁️  Condition: {weather_desc}")
    output.append(f"💧 Humidity: {humidity}%")
    output.append(f"💨 Wind: {wind} km/h")
    output.append("-" * 40)

    # Daily forecast
    daily = data.get("daily", {})
    if daily:
        output.append("\n📅 Daily Forecast:")
        dates = daily.get("time", [])
        max_temps = daily.get("temperature_2m_max", [])
        min_temps = daily.get("temperature_2m_min", [])

        for i, date in enumerate(dates[:3]):
            if i < len(max_temps) and i < len(min_temps):
                if unit == 'f':
                    max_temp = max_temps[i] * 9/5 + 32
                    min_temp = min_temps[i] * 9/5 + 32
                    output.append(f"  {date}: {min_temp:.1f}°F - {max_temp:.1f}°F")
                else:
                    output.append(f"  {date}: {min_temps[i]}°C - {max_temps[i]}°C")

    return "\n".join(output)


def main():
    parser = argparse.ArgumentParser(
        description='Get weather information for a location.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  python weather.py London
  python weather.py "New York"
  python weather.py Tokyo -u f
  python weather.py Paris --unit c
        '''
    )
    parser.add_argument(
        'location',
        nargs='?',
        help='City name (e.g., London, "New York", Tokyo)'
    )
    parser.add_argument(
        '-u', '--unit',
        choices=['c', 'f', 'b'],
        default='c',
        help='Temperature unit: c=Celsius, f=Fahrenheit, b=both (default: c)'
    )
    parser.add_argument(
        '--version',
        action='version',
        version='%(prog)s 1.1.0'
    )

    args = parser.parse_args()

    if not args.location:
        args.location = input("Enter location (city name): ").strip()
        if not args.location:
            parser.error("Please provide a location.")

    print(f"\nFetching weather for '{args.location}'...")

    # Try wttr.in first
    data = get_weather_wttr(args.location)
    if data:
        print(format_weather_wttr(data, args.location, args.unit))
    else:
        print("Failed to fetch weather data. Please check your internet connection.")


if __name__ == "__main__":
    main()
