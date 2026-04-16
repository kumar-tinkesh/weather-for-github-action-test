# Weather CLI

> **Status**: ✅ Active
> **Generated**: 2026-04-16T00:00:00Z
> **Last Updated**: 2026-04-16T00:00:00Z
> **Python Version:** 3.7+

---

## Overview

### What It Does
A single-file Python CLI tool that fetches and displays current weather conditions plus a 3-day forecast for any city, using free public APIs that require no API key.

### Why It Exists
Provides a zero-dependency, zero-configuration weather lookup tool runnable from any terminal with Python 3.7+.

### Key Capabilities
- Current temperature (Celsius, Fahrenheit, or both)
- Current conditions: humidity, wind speed, weather description
- 3-day forecast
- Two independent API backends (wttr.in primary, Open-Meteo secondary)
- Interactive location prompt when no argument is supplied

---

## Architecture

### Function Breakdown

| Function | Purpose | Key Logic |
|----------|---------|-----------|
| `main()` | CLI entry point | Parses args, prompts if no location, calls wttr.in |
| `get_weather_wttr(location)` | Fetch from wttr.in | URL-encodes location, sets User-Agent, 10s timeout |
| `get_weather_openmeteo(lat, lon, location_name)` | Fetch from Open-Meteo | Requires lat/lon coords, appends `location_name` to response |
| `format_weather_wttr(data, location, unit)` | Format wttr.in response | Builds emoji output with 3-day forecast; handles c/f/b units |
| `format_weather_openmeteo(data, unit)` | Format Open-Meteo response | Maps WMO codes to descriptions; converts temps for f/b units |

### Data Flow
```
CLI args → main() → get_weather_wttr() → wttr.in API
                          ↓
                  format_weather_wttr() → stdout
```

Open-Meteo functions are defined as a secondary/fallback backend but are not invoked by `main()` directly — they can be called programmatically when lat/lon coordinates are available.

### Components

#### Core Functions
| Function | File | Purpose |
|----------|------|---------|
| `main()` | `weather.py` | Entry point; handles CLI args and interactive prompt |
| `get_weather_wttr()` | `weather.py` | Fetches weather from wttr.in API |
| `get_weather_openmeteo()` | `weather.py` | Fetches weather from Open-Meteo API |
| `format_weather_wttr()` | `weather.py` | Formats wttr.in JSON for terminal display |
| `format_weather_openmeteo()` | `weather.py` | Formats Open-Meteo JSON for terminal display |

#### External Dependencies
| Dependency | Purpose | Source |
|------------|---------|--------|
| `urllib.request` | HTTP requests | Python standard library |
| `urllib.parse` | URL encoding | Python standard library |
| `json` | JSON parsing | Python standard library |
| `argparse` | CLI argument parsing | Python standard library |
| `datetime` | Date handling | Python standard library |

---

## API Sources

### Primary: wttr.in

**Endpoint:** `https://wttr.in/{location}?format=j1`

**Request:**
```python
# Source: weather.py:16-21
encoded_location = urllib.parse.quote(location)
url = f"https://wttr.in/{encoded_location}?format=j1"

req = urllib.request.Request(url, headers={"User-Agent": "curl/7.68.0"})
with urllib.request.urlopen(req, timeout=10) as response:
    data = json.loads(response.read().decode("utf-8"))
```

**Response Structure:**
```json
{
  "current_condition": [{ "temp_C": "...", "temp_F": "...", "weatherDesc": [...], "humidity": "...", "windspeedKmph": "..." }],
  "weather": [{ "date": "...", "maxtempC": "...", "mintempC": "...", "maxtempF": "...", "mintempF": "...", "hourly": [...] }]
}
```

**Fields Used:**
| Field | Description |
|-------|-------------|
| `current_condition[0].temp_C` | Current temperature in Celsius |
| `current_condition[0].temp_F` | Current temperature in Fahrenheit |
| `current_condition[0].weatherDesc[0].value` | Weather condition description |
| `current_condition[0].humidity` | Humidity percentage |
| `current_condition[0].windspeedKmph` | Wind speed in km/h |
| `weather[].date` | Forecast date |
| `weather[].maxtempC` / `maxtempF` | Daily max temperature |
| `weather[].mintempC` / `mintempF` | Daily min temperature |
| `weather[].hourly[4].weatherDesc[0].value` | Mid-day condition description |

### Secondary: Open-Meteo

**Endpoint:** `https://api.open-meteo.com/v1/forecast`

**Request:**
```python
# Source: weather.py:30-36
url = (
    f"https://api.open-meteo.com/v1/forecast?"
    f"latitude={lat}&longitude={lon}"
    f"&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m"
    f"&daily=temperature_2m_max,temperature_2m_min"
    f"&timezone=auto"
)
```

**WMO Weather Codes:**
| Code | Description |
|------|-------------|
| 0 | Clear sky |
| 1 | Mainly clear |
| 2 | Partly cloudy |
| 3 | Overcast |
| 45, 48 | Foggy / Rime fog |
| 51, 53, 55 | Light / Moderate / Dense drizzle |
| 61, 63, 65 | Slight / Moderate / Heavy rain |
| 71, 73, 75 | Slight / Moderate / Heavy snow |
| 77 | Snow grains |
| 80, 81, 82 | Rain showers (slight to violent) |
| 85, 86 | Snow showers |
| 95 | Thunderstorm |
| 96, 99 | Thunderstorm with hail |

---

## Configuration

### Python Version
- **Required**: Python 3.7+

### Dependencies
```
# No external dependencies required
# Uses only Python standard library
```

### System Requirements
- Internet connection
- Access to `wttr.in` and/or `api.open-meteo.com`

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

# Interactive prompt (no argument)
python weather.py

# Show version
python weather.py --version
```

### Fetching Weather (wttr.in)
```python
# Source: weather.py:12-24
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

### Fetching Weather (Open-Meteo)
```python
# Source: weather.py:27-45
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

### Formatting Output (wttr.in)
```python
# Source: weather.py:48-91
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
# Source: weather.py:160-195
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

| Error Type | Location | Handling | User Message |
|------------|----------|----------|--------------|
| Network error (wttr.in) | `get_weather_wttr()` | `try/except Exception` with 10s timeout | `"Error fetching weather: {e}"` |
| Network error (Open-Meteo) | `get_weather_openmeteo()` | `try/except Exception` with 10s timeout | `"Error fetching weather: {e}"` |
| Null data returned | `format_weather_wttr()` / `format_weather_openmeteo()` | Guard on `if not data` | `"Could not fetch weather data."` |
| No location provided | `main()` | Interactive prompt; `parser.error()` if still empty | `"Please provide a location."` |
| wttr.in fetch failure | `main()` | Prints failure message | `"Failed to fetch weather data. Please check your internet connection."` |

---

## Known Issues & Limitations

| Issue | Description |
|-------|-------------|
| Open-Meteo not wired in `main()` | `get_weather_openmeteo()` is defined but `main()` only calls wttr.in; no automatic fallback |
| No caching | Fetches fresh data on every invocation |
| 3-day forecast cap | wttr.in forecast is sliced to `[:3]`; Open-Meteo daily forecast is also capped at 3 |
| wttr.in User-Agent required | Requests without `User-Agent: curl/7.68.0` may be blocked |
| Fahrenheit display (Open-Meteo) | `format_weather_openmeteo` computes Fahrenheit at display time from Celsius base |

---

## Troubleshooting

### Common Issues

#### "Could not fetch weather data."
**Cause:** Network issue, API unavailable, or `None` returned from fetch function.
**Solution:**
1. Check internet connection
2. Verify `wttr.in` is accessible
3. Retry after a brief wait

#### Location not found / incorrect weather
**Cause:** City name not recognized by wttr.in geocoder.
**Solution:**
1. Use the English spelling of the city name
2. Wrap multi-word names in quotes: `"New York"`
3. Try a nearby major city

#### `python weather.py --version` shows wrong version
**Cause:** Running a cached `.pyc` file.
**Solution:** Delete `__pycache__/` and re-run.

---

## Related Features

- None (single-feature CLI)

---

**Generated:** 2026-04-16T00:00:00Z
**Last Updated:** 2026-04-16T00:00:00Z
**Python Version:** 3.7+
**Version:** 1.1.0
**Status:** ✅ Active
