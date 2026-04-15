# Weather Checker Documentation

> Documentation for the Weather Checker CLI application.

---

## Documentation Overview

This repository contains comprehensive documentation for the Weather Checker CLI tool, organized into three types:

| Type | Audience | Location | Status |
|------|----------|----------|--------|
| **Technical Docs** | Developers | `docs/technical/` | ⬜ Pending |
| **Knowledge Base** | End Users | `docs/knowledge-base/` | ⬜ Pending |
| **User Manuals** | End Users | `docs/user-manuals/` | ⬜ Pending |

---

## Documentation Types

### Technical Documentation
Detailed technical reference for developers working on the codebase.

- Function-level documentation
- API integration details
- Code architecture
- Error handling patterns

### Knowledge Base
Customer-friendly explanations of features and capabilities.

- What the CLI does
- Key features and capabilities
- FAQs
- Tips and best practices

### User Manuals
Step-by-step guides for using the CLI.

- Installation instructions
- Command syntax and examples
- Troubleshooting guides
- Common use cases

---

## Quick Links

- [Main Repository](/README.md)
- [Weather CLI Technical Doc](technical/weather-cli.md) — ⬜ Pending
- [Weather CLI Knowledge Base](knowledge-base/weather-cli.md) — ⬜ Pending
- [Weather CLI User Manual](user-manuals/weather-cli.md) — ⬜ Pending

---

## Documentation Workflow

This project uses automated documentation generation via Claude Code:

1. **Code changes** trigger the `update-docs.yml` workflow
2. **Claude Code** analyzes changes and updates documentation
3. **Documentation PR** is created for review
4. **Merge** triggers `sync-to-mintlify.yml` to sync to the docs site

### Manual Generation

You can also generate documentation manually:

```bash
# Generate technical documentation
/generate-feature-doc weather-cli

# Generate Knowledge Base
/generate-kb-doc

# Generate User Manual
/generate-user-manual

# Update all documentation
/update-docs
```

---

## File Organization

```
docs/
├── README.md              # This file — documentation index
├── catalog.md            # Feature catalog and mapping
├── technical/            # Technical documentation
│   └── weather-cli.md   # CLI technical reference
├── knowledge-base/       # Customer-facing KB articles
│   └── weather-cli.md   # CLI overview and FAQ
├── user-manuals/        # Step-by-step user guides
│   └── weather-cli.md   # CLI usage manual
└── api-docs/           # API documentation (if applicable)
```

---

## Contributing

When making code changes:

1. Update the code in `weather.py`
2. Commit and push to trigger documentation workflow
3. Review the auto-generated documentation PR
4. Merge when approved

For manual documentation updates:

1. Use the custom Claude Code commands
2. Review generated documentation
3. Commit changes to a documentation branch
4. Create PR for review

---

## Status

| Document | Status | Last Updated |
|----------|--------|--------------|
| Technical Documentation | ⬜ Pending | — |
| Knowledge Base | ⬜ Pending | — |
| User Manual | ⬜ Pending | — |

---

**Last Updated:** 2026-04-15
