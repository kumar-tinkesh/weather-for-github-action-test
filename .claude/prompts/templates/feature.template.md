# [Feature Name]

> **Status**: ✅ Active | ⚠️ Beta | 🚫 Deprecated
> **Generated**: [YYYY-MM-DDTHH:MM:SSZ]
> **Last Updated**: [YYYY-MM-DDTHH:MM:SSZ]
> **Python Version:** [e.g., 3.7+]

---

## Feature Documentation Standards

### Purpose
Feature documentation is FOR developers. It provides:
- Clear understanding of what the feature does
- Technical implementation details
- Code examples and API usage
- Configuration requirements
- Troubleshooting guidance

### Content Requirements

#### Must Include:
1. **Overview**: What the feature does, why it exists
2. **Architecture**: Function breakdown and data flow
3. **API Sources**: External APIs used (endpoints, responses)
4. **Configuration**: Dependencies, Python version
5. **Usage Examples**: Verbatim code from the codebase
6. **Error Handling**: How errors are caught and displayed
7. **Known Issues / Limitations**: Any caveats
8. **Related Features**: Links to related documentation

### Critical Rules
- **NEVER simplify code snippets** — copy verbatim from source
- **NEVER fabricate method names** — if you can't find it, don't document it
- **Document ALL functions** — not just the main entry point
- **Include actual API endpoints** used in the code

---

## Overview

### What It Does
[One paragraph explaining the feature's purpose and main functionality]

### Why It Exists
[Business justification or user need this addresses]

### Key Capabilities
- [Capability 1]
- [Capability 2]
- [Capability 3]

---

## Architecture

### Function Breakdown

| Function | Purpose | Key Logic |
|----------|---------|-----------|
| `function_name()` | [What it does] | [Key implementation details] |

### Data Flow
```
[Input] → [Function 1] → [Function 2] → [Output/API]
```

### Components

#### Core Functions
| Function | File | Purpose |
|----------|------|---------|
| `main()` | `weather.py` | Entry point, handles CLI args |
| `get_weather_wttr()` | `weather.py` | Fetches from wttr.in API |
| `format_weather_wttr()` | `weather.py` | Formats output with emojis |

#### External Dependencies
| Dependency | Purpose | Source |
|------------|---------|--------|
| `urllib` | HTTP requests | Python standard library |
| `json` | JSON parsing | Python standard library |

---

## API Sources

### Primary: wttr.in

**Endpoint:** `https://wttr.in/{location}?format=j1`

**Response Structure:**
```json
{
  "current_condition": [...],
  "weather": [...]
}
```

**Fields Used:**
| Field | Description |
|-------|-------------|
| `temp_C` | Temperature in Celsius |
| `temp_F` | Temperature in Fahrenheit |
| `weatherDesc` | Weather condition description |
| `humidity` | Humidity percentage |
| `windspeedKmph` | Wind speed in km/h |

### Secondary: Open-Meteo

**Endpoint:** `https://api.open-meteo.com/v1/forecast`

**Parameters:**
- `latitude`, `longitude`
- `current` — temperature, humidity, weather_code, wind_speed
- `daily` — temperature max/min

**WMO Weather Codes:**
| Code | Description |
|------|-------------|
| 0 | Clear sky |
| 1-3 | Cloudy (increasing) |
| 45, 48 | Foggy |
| 51-55 | Drizzle |
| 61-65 | Rain |
| 71-75 | Snow |
| 95-99 | Thunderstorm |

---

## Configuration

### Python Version
- **Required**: Python 3.7+
- **Tested on**: [version]

### Dependencies
```
# No external dependencies required
# Uses only Python standard library
```

### System Requirements
- Internet connection
- Access to wttr.in and Open-Meteo APIs

---

## Usage Examples

> **CRITICAL**: Code snippets MUST be verbatim copies from weather.py.

### Basic Usage
```python
# Source: weather.py:131

def main():
    if len(sys.argv) < 2:
        location = input("Enter location (city name): ").strip()
        if not location:
            print("Please provide a location.")
            print("Usage: python weather.py <location>")
            sys.exit(1)
    else:
        location = " ".join(sys.argv[1:])
```

### Fetching Weather Data
```python
# Source: weather.py:11

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

---

## Error Handling

| Error Type | Handling | User Message |
|------------|----------|--------------|
| Network error | try/except with timeout | "Error fetching weather: {e}" |
| Invalid location | Returns None | "Could not fetch weather data." |
| No location provided | Input validation | "Please provide a location." |

---

## Known Issues & Limitations

| Issue | Location | Description |
|-------|----------|-------------|
| API dependency | External | Relies on wttr.in availability |
| No caching | weather.py | Fetches fresh data every time |
| Limited forecast | Output | Only shows 3-day forecast |

---

## Troubleshooting

### Common Issues

#### Issue: "Could not fetch weather data."
**Cause:** Network issue or API unavailable
**Solution:**
1. Check internet connection
2. Verify wttr.in is accessible
3. Try again in a few minutes

#### Issue: Location not found
**Cause:** Invalid city name or API can't geocode
**Solution:**
1. Use the English name of the city
2. Try a nearby major city
3. Check spelling

---

## Related Features

- None (single-feature CLI)

---

**Generated:** [YYYY-MM-DDTHH:MM:SSZ]
**Last Updated:** [YYYY-MM-DDTHH:MM:SSZ]
**Python Version:** 3.7+
**Status:** ✅ Active
