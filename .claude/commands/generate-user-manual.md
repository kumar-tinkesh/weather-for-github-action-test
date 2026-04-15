---
description: Generate User Manual for the weather CLI. Usage: /generate-user-manual
---

You are tasked with generating a step-by-step User Manual for the Weather Checker CLI application.

## Project Structure

This is a simple Python CLI tool:
- `weather.py` — Single-file CLI application
- Fetches weather from free APIs (no API key required)

## Instructions

1. **Read the Knowledge Base doc** at `docs/knowledge-base/weather-cli.md` (or generate it first)

2. **Read the user manual template** at `.claude/prompts/templates/user-manual.template.md`

3. **Read the source code** at `weather.py` to understand:
   - Command-line arguments accepted
   - Interactive input mode
   - Output format (what users see)
   - Error messages displayed

4. **Generate the user manual** with:
   - Prerequisites (Python, internet)
   - Installation steps
   - Step-by-step usage instructions
   - Example commands for common scenarios
   - Troubleshooting section

5. **Save the output** to `docs/user-manuals/weather-cli.md`
   - Create the directory if it doesn't exist

## Content Guidelines

### Prerequisites Section:
- Python 3.7 or higher
- Internet connection
- No API keys needed

### Installation:
```bash
# Clone or download the repository
git clone <repo-url>
cd weather-checker

# Optional: create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### Usage Instructions:
- Use **bold** for commands, arguments, and UI elements
- Write in second person ("You")
- One action per step
- Include expected output examples

### Example Commands to Document:
```bash
# Basic usage
python weather.py London

# Multi-word city names
python weather.py "New York"

# Interactive mode
python weather.py
# Then enter city name when prompted
```

## Quality Standards

- **Exact command syntax** — verify commands work as written
- **Complete workflows** — cover installation through usage
- **Real examples** — show actual output format
- **Troubleshooting** — minimum 3 common issues
- **No technical jargon** — accessible to non-developers

## Common Mistakes to Avoid

1. **Wrong command syntax** — always verify `python weather.py` not `python3` unless specified
2. **Missing quote examples** — cities with spaces need quotes
3. **No output examples** — show what users actually see
4. **Skipping error cases** — document what happens with bad input
5. **Technical requirements** — don't mention urllib, json, etc.

Begin by reading the source code, then generate the user manual.
