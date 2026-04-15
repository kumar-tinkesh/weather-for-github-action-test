# Weather Checker CLI

> Get current weather and 3-day forecasts for any city — no API key required.

---

## What is Weather Checker?

Weather Checker is a simple command-line tool that fetches current weather conditions and forecasts for any city worldwide. Just type a city name and get instant weather information including temperature, humidity, wind speed, and a 3-day forecast.

---

## Key Capabilities

- **Current Weather** — See the current temperature, conditions, humidity, and wind speed
- **3-Day Forecast** — Plan ahead with a multi-day weather outlook
- **Global Coverage** — Works with any city name worldwide
- **No Setup Required** — No API keys, no accounts, just run and go
- **Dual Temperature Display** — Shows both Celsius and Fahrenheit

---

## How It Works

1. **Enter a City Name** — Type the name of any city
2. **Fetch Data** — The tool connects to free weather APIs
3. **View Results** — See current conditions and forecast with clear, emoji-enhanced formatting

The weather data comes from reliable public weather services:
- **wttr.in** — Primary data source for current conditions and forecast
- **Open-Meteo** — Secondary source with additional weather details

---

## Common Questions

**Q: Do I need an API key to use Weather Checker?**
A: No. The tool uses free, public weather APIs that don't require registration or API keys.

**Q: What cities are supported?**
A: Any city name worldwide should work. Try major cities first if you're unsure of the exact spelling.

**Q: Can I check the weather for multiple cities at once?**
A: Currently, the tool displays weather for one city at a time. Run it again for additional cities.

**Q: How current is the weather data?**
A: The data is fetched in real-time when you run the command, so it's always up-to-date.

**Q: What weather information do I get?**
A: You receive: current temperature (°C and °F), weather conditions (sunny, cloudy, rain, etc.), humidity percentage, wind speed, and a 3-day temperature forecast.

**Q: Does it work offline?**
A: No, an internet connection is required to fetch weather data from the APIs.

**Q: Can I use this commercially?**
A: Yes, the tool is open source under the MIT license.

**Q: What if my city isn't found?**
A: Try the English name of the city, or use a nearby major city. The APIs recognize most common city names.

---

## Tips & Best Practices

- **Use quotes for multi-word cities** — When typing city names with spaces like "New York", use quotes
- **Check nearby cities** — If your small town isn't found, try the nearest major city
- **Run regularly** — Weather changes frequently, so check before planning outdoor activities
- **Temperature in both scales** — The display shows both Celsius and Fahrenheit for convenience

---

## Limitations & Important Notes

- Requires an active internet connection
- Limited to 3-day forecast (not extended forecasts)
- Depends on third-party API availability
- No historical weather data

---

## Related Features

- None (standalone CLI tool)

---

## Content Rules (remove this section from generated docs)

### What to include:
- Customer-visible behavior only
- What users can see and do
- Plain-language explanations
- Actual output format description

### What to NEVER include:
- Code snippets of any kind
- File paths or Python module names
- API endpoint URLs (just mention "free APIs")
- Technical implementation details
- Function or method names
- Dependencies or library names
- Error stack traces
