# Weather Checker CLI — User Manual

> Step-by-step instructions for checking weather from the command line.

---

## Prerequisites

- **Python 3.7 or higher** installed on your system
- **Internet connection** to fetch weather data
- **No API key required** — the tool uses free public APIs

---

## Overview

This guide walks you through installing and using Weather Checker to get current weather conditions and 3-day forecasts for any city worldwide.

---

## Installation

### Step 1: Download or Clone

Download the `weather.py` file or clone the repository:

```bash
git clone <repo-url>
cd weather-checker
```

### Step 2: Verify Python Version

Check that Python 3.7+ is installed:

```bash
python --version
```

You should see output like: `Python 3.9.0` or higher.

### Expected Result

The `weather.py` file is now available in your directory and ready to use.

---

## Checking Weather — Quick Method

### Steps

1. Open your terminal or command prompt

2. Navigate to the directory containing `weather.py`

3. Run the command with a city name:
   ```bash
   python weather.py London
   ```

### Expected Result

You'll see output like:
```
🌍 Weather for: London
----------------------------------------
🌡️  Temperature: 15°C / 59°F
☁️  Condition: Partly cloudy
💧 Humidity: 72%
💨 Wind: 14 km/h
----------------------------------------

📅 3-Day Forecast:
  2024-01-15: 8°C - 16°C, Partly cloudy
  2024-01-16: 6°C - 14°C, Light rain
  2024-01-17: 7°C - 15°C, Overcast
```

---

## Checking Weather — Interactive Method

### Steps

1. Open your terminal

2. Navigate to the weather-checker directory

3. Run the command without arguments:
   ```bash
   python weather.py
   ```

4. When prompted, type a city name and press **Enter**:
   ```
   Enter location (city name): Tokyo
   ```

### Expected Result

The weather information for Tokyo will display, showing current conditions and the 3-day forecast.

---

## Working with Multi-Word City Names

### Steps

1. For cities with spaces in the name, use quotation marks:
   ```bash
   python weather.py "New York"
   ```

2. Or use the interactive method:
   ```bash
   python weather.py
   Enter location (city name): New York
   ```

### Expected Result

Weather data for New York displays correctly.

---

## Troubleshooting

### "Could not fetch weather data."

**Cause:** Network connection issue or API temporarily unavailable
**Solution:**
1. Check your internet connection
2. Wait a minute and try again
3. Verify the city name is spelled correctly

### "Please provide a location."

**Cause:** Ran the command without specifying a city
**Solution:**
1. Add a city name to the command: `python weather.py London`
2. Or use interactive mode and enter a city when prompted

### "python" command not found

**Cause:** Python is not installed or not in your system PATH
**Solution:**
1. Install Python 3.7+ from python.org
2. On some systems, use `python3` instead of `python`: `python3 weather.py London`

### City not found

**Cause:** The API doesn't recognize the city name
**Solution:**
1. Try the English name of the city
2. Use a nearby major city
3. Check the spelling

---

## Content Rules (remove this section from generated docs)

### How to extract details from code:
1. **Command syntax** — from the `main()` function in weather.py
2. **Prompt text** — from the `input()` call
3. **Error messages** — from `print()` statements
4. **Output format** — from the format functions

### What to NEVER include:
- Code snippets
- File paths
- Technical implementation details
- Python module names

### Style guidelines:
- Use **bold** for commands, arguments, and UI elements
- Write in second person ("You")
- One action per step
- Include "Expected Result" after each task
