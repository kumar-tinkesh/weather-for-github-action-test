---
description: Generate technical documentation for the weather CLI. Usage: /generate-feature-doc [feature-name]
---

You are tasked with generating technical documentation for the Weather Checker CLI application.

## Project Structure

This is a simple Python CLI tool with a single file:
- `weather.py` — Main application file containing all functionality

## Instructions

1. **Read the existing code** at `weather.py` to understand the current implementation

2. **Read the feature catalog** at `docs/catalog.md` (create if it doesn't exist)

3. **Read the feature template** at `.claude/prompts/templates/feature.template.md`

4. **Analyze the codebase** — for a single-file CLI, focus on:
   - Functions and their purposes
   - API integrations (wttr.in, Open-Meteo)
   - Data formatting and output
   - Error handling
   - Command-line interface

5. **Generate the documentation** following the template structure:
   - Overview (what the feature does)
   - Architecture (function breakdown)
   - API Sources (wttr.in and Open-Meteo details)
   - Configuration (Python version, dependencies)
   - Usage Examples (actual command examples)
   - Error Handling
   - Known Issues & Limitations

6. **Save the output** to `docs/technical/<feature-name>.md`
   - Create the directory if it doesn't exist

## Quality Standards

- **Verbatim code only** — copy actual code snippets from weather.py
- **Complete function documentation** — document all functions, not just main ones
- **Real examples** — include actual working command examples
- **Accurate API details** — document the actual endpoints used
- Add "Generated: YYYY-MM-DDTHH:MM:SSZ" and "Last Updated: YYYY-MM-DDTHH:MM:SSZ" timestamps

## Common Mistakes to Avoid

1. **Simplified code snippets** — always show actual code from weather.py
2. **Missing functions** — document helper functions like formatters, not just get_weather_
3. **Incorrect API endpoints** — verify the actual URLs used in the code
4. **Missing error handling** — document how errors are caught and displayed
5. **Outdated Python version** — check requirements.txt for the actual version required

Begin by reading the code in weather.py, then generate the technical documentation.
