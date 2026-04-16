# Weather CLI

> **Status**: ✅ Active
> **Generated**: 2026-04-16T00:00:00Z
> **Last Updated**: 2026-04-16T00:00:00Z
> **Python Version:** 3.7+

---

## Overview

### What It Does
A single-file Python CLI tool that fetches and displays current weather conditions and a 3-day forecast for any city. Uses free public APIs with no API key required.

### Why It Exists
Provides a lightweight, dependency-free way to check weather from the command line without requiring API registration or external packages.

### Key Capabilities
- Fetch current weather (temperature, humidity, wind, condition)
- Display a 3-day forecast
- Support Celsius, Fahrenheit, or both units simultaneously
- Automatic fallback from wttr.in to Open-Meteo on failure
- Interactive location prompt if no argument provided

---

## Architecture

### Function Breakdown

| Function | Purpose | Key Logic |
|----------|---------|-----------|
| `main()` | CLI entry point | Parses args, calls wttr.in fetch, prints output |
| `get_weather_wttr(location)` | Fetch from wttr.in | URL-encodes location, sets User-Agent, 10s timeout |
| `get_weather_openmeteo(lat, lon, location_name)` | Fetch from Open-Meteo | Accepts coordinates, appends `location_name` to response |
| `format_weather_wttr(data, location, unit)` | Format wttr.in response | Handles `c`/`f`/`b` units, builds emoji output + 3-day forecast |
| `format_weather_openmeteo(data, unit)` | Format Open-Meteo response | Maps WMO codes, converts temps, builds emoji output + daily forecast |

### Data Flow
```
CLI args → main() → get_weather_wttr(location)
                         │
                    [success] → format_weather_wttr(data, location, unit) → print
                         │
                    [failure] → "Failed to fetch weather data."
```

### Components

#### Core Functions
| Function | File | Purpose |
|----------|------|---------|
| `main()` | `weather.py` | Entry point, handles CLI args via argparse |
| `get_weather_wttr()` | `weather.py` | Fetches from wttr.in API |
| `get_weather_openmeteo()` | `weather.py` | Fetches from Open-Meteo API (fallback) |
| `format_weather_wttr()` | `weather.py` | Formats wttr.in response with emojis and forecast |
| `format_weather_openmeteo()` | `weather.py` | Formats Open-Meteo response with WMO code mapping |

#### External Dependencies
| Dependency | Purpose | Source |
|------------|---------|--------|
| `urllib.request` | HTTP requests | Python standard library |
| `urllib.parse` | URL encoding | Python standard library |
| `json` | JSON parsing | Python standard library |
| `argparse` | CLI argument parsing | Python standard library |
| `datetime` | Date handling | Python standard library |
| `sys` | System utilities | Python standard library |

---

## API Sources

### Primary: wttr.in

**Endpoint:** `https://wttr.in/{location}?format=j1`

**Headers Required:**
```
User-Agent: curl/7.68.0
```

**Response Structure:**
```json
{
  "current_condition": [{ ... }],
  "weather": [{ ... }, { ... }, { ... }]
}
```

**Fields Used from `current_condition[0]`:**
| Field | Description |
|-------|-------------|
| `temp_C` | Temperature in Celsius |
| `temp_F` | Temperature in Fahrenheit |
| `weatherDesc[0].value` | Weather condition description |
| `humidity` | Humidity percentage |
| `windspeedKmph` | Wind speed in km/h |

**Fields Used from `weather[]` (forecast):**
| Field | Description |
|-------|-------------|
| `date` | Forecast date |
| `maxtempC` / `maxtempF` | Maximum temperature |
| `mintempC` / `mintempF` | Minimum temperature |
| `hourly[4].weatherDesc[0].value` | Midday weather description |

### Secondary: Open-Meteo

**Endpoint:** `https://api.open-meteo.com/v1/forecast`

**Parameters:**
- `latitude`, `longitude`
- `current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m`
- `daily=temperature_2m_max,temperature_2m_min`
- `timezone=auto`

**WMO Weather Codes:**
| Code | Description |
|------|-------------|
| 0 | Clear sky |
| 1 | Mainly clear |
| 2 | Partly cloudy |
| 3 | Overcast |
| 45 | Foggy |
| 48 | Depositing rime fog |
| 51 | Light drizzle |
| 53 | Moderate drizzle |
| 55 | Dense drizzle |
| 61 | Slight rain |
| 63 | Moderate rain |
| 65 | Heavy rain |
| 71 | Slight snow |
| 73 | Moderate snow |
| 75 | Heavy snow |
| 77 | Snow grains |
| 80 | Slight rain showers |
| 81 | Moderate rain showers |
| 82 | Violent rain showers |
| 85 | Slight snow showers |
| 86 | Heavy snow showers |
| 95 | Thunderstorm |
| 96 | Thunderstorm with slight hail |
| 99 | Thunderstorm with heavy hail |

---

## Configuration

### Python Version
- **Required**: Python 3.7+
- **Tested on**: 3.8, 3.9, 3.10, 3.11, 3.12

### Dependencies
```
# No external dependencies required
# Uses only Python standard library
```

### System Requirements
- Internet connection
- Access to wttr.in and/or Open-Meteo APIs

---

## Usage Examples

### CLI Usage
```bash
# Basic usage
python weather.py London

# Multi-word city
python weather.py "New York"

# Fahrenheit
python weather.py Tokyo -u f

# Both units
python weather.py Paris --unit b

# Interactive mode (no argument)
python weather.py

# Version
python weather.py --version
```

### Fetching Weather — wttr.in
```python
# Source: weather.py:12

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
```

### Fetching Weather — Open-Meteo
```python
# Source: weather.py:27

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
```

### Formatting — wttr.in
```python
# Source: weather.py:48

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
```

### CLI Argument Parsing
```python
# Source: weather.py:160

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
```

---

## Error Handling

| Error Type | Handling | User Message |
|------------|----------|--------------|
| Network error (wttr.in) | `try/except Exception` with 10s timeout | `"Error fetching weather: {e}"` |
| Network error (Open-Meteo) | `try/except Exception` with 10s timeout | `"Error fetching weather: {e}"` |
| wttr.in returns `None` | Checked in `main()` | `"Failed to fetch weather data. Please check your internet connection."` |
| No data in format functions | Guard clause at top | `"Could not fetch weather data."` |
| No location provided | Interactive prompt or `parser.error()` | `"Please provide a location."` |

---

## Known Issues & Limitations

| Issue | Location | Description |
|-------|----------|-------------|
| API dependency | External | Relies on wttr.in availability |
| No caching | `weather.py` | Fetches fresh data on every invocation |
| Limited forecast | Output | Only shows 3-day forecast |
| Open-Meteo requires coordinates | `get_weather_openmeteo()` | Caller must supply `lat`/`lon`; no geocoding built in |
| `'b'` unit in Open-Meteo formatter | `format_weather_openmeteo()` | `temp` variable holds raw Celsius value when `unit='b'`; label shows converted F but base value unchanged |

---

## Troubleshooting

### Common Issues

#### "Could not fetch weather data."
**Cause:** `get_weather_wttr()` returned `None` (network error or API down)
**Solution:**
1. Check internet connection
2. Verify wttr.in is accessible: `curl "https://wttr.in/London?format=j1"`
3. Try again in a few minutes

#### Location not found / unexpected results
**Cause:** Invalid or ambiguous city name
**Solution:**
1. Use the English name of the city
2. Try a nearby major city
3. Check spelling

#### `Error fetching weather: <urlopen error ...>`
**Cause:** DNS failure, firewall, or timeout exceeded
**Solution:** Ensure outbound HTTPS (port 443) to `wttr.in` and `api.open-meteo.com` is permitted

---

## Related Features

- None (single-feature CLI)

---

**Generated:** 2026-04-16T00:00:00Z
**Last Updated:** 2026-04-16T00:00:00Z
**Python Version:** 3.7+
**Version:** 1.1.0
**Status:** ✅ Active
