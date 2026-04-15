---
description: Scan existing documentation, detect changes, and update all docs
---

You are tasked with maintaining the complete documentation for the Weather Checker CLI application.

## Project Structure

This is a simple Python CLI tool:
- `weather.py` — Main application (single file)
- `requirements.txt` — Dependencies
- `docs/` — Documentation directory

## Step 1: Read Current State

1. Read `docs/catalog.md` — the feature catalog
2. Read `docs/README.md` — documentation status
3. Read `CLAUDE.md` for project context
4. List all existing files in `docs/` directory

## Step 2: Check for Code Changes

1. Read `weather.py` to understand current implementation
2. Check if technical docs exist at `docs/technical/weather-cli.md`
3. If docs exist, check the "Last Updated" timestamp
4. Compare current code with documented version

## Step 3: Update Documentation

### If changes detected in weather.py:

1. **Update Technical Documentation** (`docs/technical/weather-cli.md`):
   - Read the existing doc
   - Identify what changed in the code
   - Update affected sections
   - Update "Last Updated" timestamp

2. **Update Knowledge Base** (`docs/knowledge-base/weather-cli.md`):
   - Re-derive from updated technical doc
   - Remove technical content
   - Update FAQ if behavior changed
   - Update "Last Updated" timestamp

3. **Update User Manual** (`docs/user-manuals/weather-cli.md`):
   - Update if command syntax changed
   - Update if output format changed
   - Update if error messages changed
   - Update "Last Updated" timestamp

### If no changes detected:
- Skip update
- Report that docs are current

## Step 4: Update Index

Update `docs/README.md` with:
- Current documentation status
- Links to all generated docs
- Last scan date

## Step 5: Summary Report

```
Documentation Update Summary
=============================
Code changes detected:     Yes / No
Technical doc updated:     Yes / No / N/A
Knowledge Base updated:    Yes / No / N/A
User Manual updated:       Yes / No / N/A
Files modified:            N files
Status:                    All docs current / Updates applied
```

## Quality Standards

- **Verbatim code** — copy actual code from weather.py
- **Complete coverage** — all functions documented
- **Customer-friendly** — KB and manual have zero technical content
- **Accurate examples** — commands actually work
- Timestamps in ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ)

## Common Mistakes to Avoid

1. **Not checking timestamps** — always verify when docs were last updated
2. **Missing function changes** — document all new or modified functions
3. **Outdated examples** — ensure command examples match current syntax
4. **Ignoring error handling** — document new error cases
5. **Stale KB content** — re-derive from technical doc when code changes

Begin by reading the current state of docs/ and weather.py.
