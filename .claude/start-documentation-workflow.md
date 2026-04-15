# Documentation Generation Workflow

## Key Files

| File | Purpose |
|------|---------|
| `docs/features/catalog.md` | **Single source of truth** — all features, subfeatures, and file-path mappings (41 doc files across 3 namespaces) |
| `docs/README.md` | Index with documentation status table |
| `docs/features/<namespace>/<feature-name>.md` | Individual feature docs (isolated, one per feature, organized by namespace) |
| `.claude/prompts/templates/feature.template.md` | Template for generating feature docs |

## Recommended: Use the `/update-docs` Command

```
/update-docs
```

This command will:
1. Read the catalog (`docs/features/catalog.md`) as source of truth
2. Check existing documentation for staleness (via git history + key paths)
3. Update docs that have underlying code changes
4. Generate docs for features that don't have documentation yet
5. Update the `docs/README.md` status table

---

## Alternative: Manual Per-Feature Generation

```
/generate-feature-doc <feature-name>
```

The command reads the feature's entry from `docs/features/catalog.md` to know what to document and which files to analyze. See the catalog for the full feature list.

#### Already Documented
All 41 doc files have initial documentation generated across namespaced directories:
- `backoffice/` — 21 docs (one per feature)
- `pos/` — 10 docs + README index (split by domain: auth, terminals, sessions, cart, search, customers, payments, receipts, fulfillment, realtime)
- `apis/` — 8 docs + README index (split by domain: auth, products, orders, customers, carts, inventory, catalog, infrastructure)
- Root — 2 docs (landing-pages, platform-infrastructure)

---

## Directory-Level Documentation

```
/app-docs       # Generates docs/app.md
/config-docs    # Generates docs/config.md
```

---

## Architecture: Isolation by Design

Each feature has its own isolated doc file at `docs/features/<namespace>/<feature-name>.md`. This isolation is intentional:

- **PR merges should only update relevant feature files** — never modify unrelated feature docs
- The `catalog.md` file includes a **Feature-to-Path Mapping** (YAML) that maps each feature slug to the file paths that affect it
- This mapping is designed for future **GitHub Actions automation**: when a PR merges, the action can diff changed files against the mapping to determine which feature docs to regenerate

---

## Prerequisites

Before generating, ensure you've read:
1. `CLAUDE.md` — Project context (tech stack, architecture)
2. `.claude/instructions.md` — Documentation standards
3. `.claude/prompts/templates/feature.template.md` — Feature doc template

## Quality Checklist

After generation, verify:
- [ ] No placeholder text — all content from actual code
- [ ] Version numbers correct (Rails 8.1.0, Ruby 4.0.1)
- [ ] Timestamps present on all files
- [ ] Mermaid diagrams render correctly
- [ ] Cross-references between docs are accurate
- [ ] `docs/README.md` status table is up to date
- [ ] Only the target feature file was created/modified

## Cost Estimates

- Per feature doc: ~$0.10–0.20
- Updates (existing docs): ~$0.05–0.10 each
