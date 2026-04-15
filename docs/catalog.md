# Feature Catalog

> Single source of truth for all Weather Checker CLI features and documentation.

---

## Overview

The Weather Checker CLI is a single-feature application that fetches and displays weather information from free public APIs.

---

## Features

### Feature 1: Weather CLI

| Field | Value |
|-------|-------|
| **Name** | Weather CLI |
| **Slug** | `weather-cli` |
| **Description** | Command-line tool for fetching current weather and 3-day forecasts |
| **Status** | ✅ Active |
| **Priority** | Core |

#### Key Paths

| Path | Description |
|------|-------------|
| `weather.py` | Main application file (single file) |
| `requirements.txt` | Python version requirements |

#### Sub-features

| Sub-feature | Description |
|-------------|-------------|
| Current Weather | Display current temperature, conditions, humidity, wind |
| 3-Day Forecast | Show upcoming weather forecast |
| Interactive Mode | Prompt for city name when no arguments provided |
| CLI Mode | Accept city name as command-line argument |

---

## Documentation Mapping

### Technical Documentation

| Feature | File Path | Status |
|---------|-----------|--------|
| weather-cli | `docs/technical/weather-cli.md` | ⬜ Pending |

### Knowledge Base

| Feature | File Path | Status |
|---------|-----------|--------|
| weather-cli | `docs/knowledge-base/weather-cli.md` | ⬜ Pending |

### User Manuals

| Feature | File Path | Status |
|---------|-----------|--------|
| weather-cli | `docs/user-manuals/weather-cli.md` | ⬜ Pending |

---

## Feature-to-Path Mapping (YAML)

```yaml
features:
  weather-cli:
    name: "Weather CLI"
    slug: "weather-cli"
    description: "Command-line tool for fetching current weather and 3-day forecasts"
    status: "active"
    priority: "core"
    paths:
      # Core application
      - "weather.py"
      - "requirements.txt"
    subfeatures:
      - current-weather
      - forecast
      - interactive-mode
      - cli-mode
    docs:
      technical: "docs/technical/weather-cli.md"
      knowledge_base: "docs/knowledge-base/weather-cli.md"
      user_manual: "docs/user-manuals/weather-cli.md"
```

---

## External API Dependencies

| API | Purpose | Endpoint |
|-----|---------|----------|
| wttr.in | Primary weather data | `https://wttr.in/{location}?format=j1` |
| Open-Meteo | Secondary weather data | `https://api.open-meteo.com/v1/forecast` |

---

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-04-15 | 1.0.0 | Initial implementation |

---

## Related Documentation

- [Documentation README](README.md)
- [Main Project README](/README.md)

---

**Last Updated:** 2026-04-15T19:00:00Z
