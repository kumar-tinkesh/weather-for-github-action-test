# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A simple Python CLI tool that fetches weather information using free APIs (no API key required).

## Running the Application

```bash
# Check weather for a city
python weather.py <city-name>

# Specify temperature unit (c=Celsius, f=Fahrenheit, b=both)
python weather.py <city-name> -u f
python weather.py <city-name> --unit b

# Examples
python weather.py London
python weather.py "New York"
python weather.py Tokyo
python weather.py Tokyo -u f
```

## Architecture

**Single-file Python script** (`weather.py`):

- **No external dependencies** - uses only Python standard library (`urllib`, `json`, `datetime`, `sys`)
- **Two weather data sources**:
  - `get_weather_wttr()` - Primary source using wttr.in API
  - `get_weather_openmeteo()` - Secondary/fallback using Open-Meteo API
- **Formatting functions**:
  - `format_weather_wttr()` - Formats wttr.in response with emojis and 3-day forecast
  - `format_weather_openmeteo()` - Formats Open-Meteo response with WMO weather code mapping

The script accepts location via command-line argument or interactive input, fetches data from wttr.in, and displays current conditions plus a 3-day forecast.

## Documentation Workflow (Two-Repo Architecture)

This project uses a two-repo documentation architecture:

### Repository 1: Main Repo (weather-checker)

Contains code and documentation source files.

#### Documentation Structure

```
docs/
├── README.md              # Documentation index
├── catalog.md             # Feature catalog and mapping
├── technical/             # Technical docs (developers)
├── knowledge-base/        # Customer-facing KB articles
├── user-manuals/          # Step-by-step user guides
└── api-docs/              # API documentation
```

#### Automated Documentation

**Workflow 1: Doc Generation** (`.github/workflows/update-docs.yml`)
- **Trigger:** Push to `main` that modifies `weather.py`
- **Process:**
  1. Detects changes to `weather.py`
  2. Runs Claude Code to update documentation
  3. Creates/updates documentation PR on branch `documentation/auto-update-{run-number}`
- **Generates:**
  - `docs/technical/weather-cli.md` — Technical reference
  - `docs/knowledge-base/weather-cli.md` — Customer FAQ
  - `docs/user-manuals/weather-cli.md` — Usage guide

**Workflow 2: Sync to Mintlify** (`.github/workflows/sync-to-mintlify.yml`)
- **Trigger:** Push to `main` that modifies customer-facing docs (`docs/knowledge-base/**`, `docs/user-manuals/**`, `docs/api-docs/**`)
- **Process:**
  1. Syncs docs to the separate `weather-checker-docs` repo
  2. Converts `.md` to `.mdx` for Mintlify
  3. Pushes directly to docs repo `main` branch
- **Requires:** `DOCS_REPO` and `DOCS_REPO_TOKEN` secrets

#### Manual Documentation Commands

Use these custom Claude Code commands to generate docs manually:

```bash
# Generate technical documentation
/generate-feature-doc weather-cli

# Generate Knowledge Base (customer-facing)
/generate-kb-doc

# Generate User Manual
/generate-user-manual

# Update all documentation
/update-docs
```

### Repository 2: Docs Repo (weather-checker-docs)

Customer-facing documentation hosted on Mintlify.

**Synced Content:**
- `guides/` ← `docs/knowledge-base/`
- `manuals/` ← `docs/user-manuals/`
- `api-reference/` ← `docs/api-docs/`

**Features:**
- Mintlify auto-deploy on push
- AI chatbot with RAG on all docs
- Customer self-service support

### End-to-End Flow

```
Code PR merge → Doc PR created → Doc PR merge → Sync to Mintlify → Mintlify deploys
```

## Development Commands

### Linting and Formatting

```bash
# Format code with Black
black weather.py

# Sort imports with isort
isort weather.py

# Lint with flake8
flake8 weather.py --count --select=E9,F63,F7,F82 --show-source --statistics
flake8 weather.py --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
```

### Testing

```bash
# Verify Python syntax
python -m py_compile weather.py

# Test CLI help
python weather.py --help

# Test weather fetch (requires internet)
python weather.py London
```

## Key Implementation Details

- Python 3.7+ required
- wttr.in API returns nested JSON with `current_condition` and `weather` arrays
- Open-Meteo uses WMO weather codes (0-99) mapped to human-readable descriptions
- 10-second timeout on HTTP requests
- User-Agent header required for wttr.in API requests
- Version flag: `python weather.py --version` (outputs 1.1.0)

## Documentation Templates

Templates are in `.claude/prompts/templates/`:
- `feature.template.md` — Technical documentation structure
- `knowledge-base.template.md` — Customer KB article structure
- `user-manual.template.md` — Step-by-step guide structure

## Secrets Required

For GitHub Actions to work:

1. `ANTHROPIC_API_KEY` — For Claude Code documentation generation
2. `DOCS_REPO` — Full name of docs repo (e.g., `username/weather-checker-docs`)
3. `DOCS_REPO_TOKEN` — Personal access token with write access to docs repo
