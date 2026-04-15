---
description: Generate Knowledge Base doc for the weather CLI. Usage: /generate-kb-doc
---

You are tasked with generating a customer-facing Knowledge Base document for the Weather Checker CLI application.

## Project Structure

This is a simple Python CLI tool:
- `weather.py` — Single-file CLI application
- Fetches weather data from free APIs (no API key required)

## Instructions

1. **Read the technical documentation** at `docs/technical/weather-cli.md` (or generate it first)

2. **Read the KB template** at `.claude/prompts/templates/knowledge-base.template.md`

3. **Read the source code** at `weather.py` to understand customer-visible behavior:
   - What weather data is displayed (temperature, humidity, wind, forecast)
   - What locations are supported
   - What APIs are used
   - How errors are handled

4. **Transform into customer-friendly documentation**:
   - Replace technical terms with plain language
   - Remove ALL code snippets, file paths, and implementation details
   - Focus on what users can do and see
   - Explain error messages in user-friendly terms

5. **Save the output** to `docs/knowledge-base/weather-cli.md`
   - Create the directory if it doesn't exist

## Content Guidelines

### What to include:
- What the weather CLI does (fetches current weather and forecast)
- How to use it (command format)
- What information it provides (temperature, conditions, humidity, wind, 3-day forecast)
- Supported locations (any city name)
- Requirements (Python 3.7+, internet connection)
- FAQ section (5-10 common questions)

### What to NEVER include:
- Python code or syntax
- Function names or file paths
- API endpoint URLs
- Technical implementation details
- Error stack traces
- Dependencies or library names

## Quality Standards

- **Zero technical content** — no code, no file paths, no technical jargon
- **Customer-friendly language** — explain as if talking to a non-technical user
- **Complete FAQ section** — minimum 5 Q&A pairs
- **Accurate information** — derived from actual code behavior
- **Working examples** — command examples that actually work

## Common Mistakes to Avoid

1. **Including code** — even simple Python snippets should be removed
2. **Technical URLs** — don't expose wttr.in API URLs to users
3. **Library names** — don't mention urllib, json, etc.
4. **File paths** — never reference `weather.py` or directory structure
5. **Developer terms** — "function", "module", "import" should not appear

Begin by reading the technical doc and source code, then generate the customer-facing KB document.
