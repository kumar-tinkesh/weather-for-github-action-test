---
description: Scan existing documentation, detect changes, and generate or update all feature docs
---

You are tasked with maintaining the complete documentation for the Skutally Rails application (Rails 8.1.0, Ruby 4.0.1). This is a single command that handles the full documentation lifecycle.

## Namespace Mapping

Features are organized into namespace directories. Features not in a namespace stay at root (`docs/features/`).

| Namespace | Directory | Features |
|-----------|-----------|----------|
| Back-office | `docs/features/backoffice/` | authentication, product-catalog, inventory-management, sales-orders, fulfillment, purchase-orders, customer-management, company-management, supplier-management, payment-processing, shipping, carts, reporting, user-account-management, account-settings, dynamic-search, printing, import-export, activity-collaboration, shopify-integration, integrations |
| POS | `docs/features/pos/` | authentication, terminals-setup, sessions-registers, cart-management, product-search, customers, payments, receipts-printing, fulfillment, realtime-hardware |
| APIs | `docs/features/apis/` | authentication, products, orders, customers, carts-checkout, inventory, catalog, infrastructure |
| Root | `docs/features/` | landing-pages, platform-infrastructure |

**Note:** POS and APIs namespaces have multiple feature docs with a `README.md` index. When updating, check each sub-feature file individually against its relevant code paths.

## Step 1: Read Current State

1. Read `docs/features/catalog.md` — the single source of truth for all features, subfeatures, and file-path mappings
2. Read `docs/README.md` — documentation status table (which features are ✅ Complete vs ⬜ Pending)
3. Read `CLAUDE.md` for project context
4. Read `.claude/prompts/templates/feature.template.md` for the documentation template
5. List all existing files in `docs/features/` and its subdirectories (`backoffice/`, `pos/`, `apis/`) to know what's already documented

## Step 1b: Detect Uncataloged Features (New Feature Discovery)

Scan the codebase for code that isn't covered by any catalog entry. This catches entirely new features that were added without updating the documentation catalog.

### How to detect:

1. **List all controllers** — `ls app/controllers/*.rb app/controllers/**/*.rb`
2. **Extract the Feature-to-Path Mapping YAML** from `catalog.md`
3. **For each controller**, check if it matches ANY pattern in the YAML mapping. If a controller file doesn't match any pattern (explicit, glob, or directory), it's potentially uncataloged.
4. **Group uncataloged controllers** with related files (models, services, views, policies) using Rails naming conventions:
   - Controller `returns_controller.rb` → model `return.rb`, service `returns/`, views `returns/`, policy `return_policy.rb`
5. **Classify each group:**
   - **New feature**: Has files in 2+ layers (controller + model, controller + service, etc.) AND the resource name is distinct from any existing catalog feature slug
   - **Missing mapping**: Files clearly belong to an existing feature (e.g., a new controller for `sales_orders` that just wasn't in the YAML) → update the YAML mapping only
   - **Trivial/supporting**: Single file that doesn't warrant its own feature doc (e.g., a utility controller) → add it to the most relevant existing feature's mapping

### For each detected NEW feature:
1. Add a new entry to `docs/features/catalog.md`:
   - Pick the next feature number
   - Write a description based on reading the actual code
   - List Key paths
2. Add file patterns to the Feature-to-Path Mapping YAML block
3. Determine the correct namespace (backoffice for most backoffice features, pos/ for POS, apis/ for API)
4. Add it to the generation queue (Step 3)
5. Update `docs/README.md` with the new feature row

### For each detected MISSING MAPPING:
1. Add the unmapped file patterns to the existing feature's YAML mapping in `catalog.md`
2. Flag the existing feature for update if the new files change its behavior

## Step 2: Detect What Needs Work

For each feature listed in `docs/features/catalog.md`:

### If documentation EXISTS (`docs/features/<namespace>/<feature-name>.md`):
1. Look for the doc in its namespace directory (use the Namespace Mapping above)
   - Also check `docs/features/<feature-name>.md` (legacy flat location) — if found there, note it for migration
2. Read the existing doc and note its "Generated" / "Last Updated" timestamp
3. Use the **Key paths** from `catalog.md` to check for code changes:
   - `git log --since="<last-updated-date>" --oneline -- <relevant-paths>` for each feature's key paths
4. If changes are found:
   - Read the changed files to understand what changed
   - Update the existing documentation to reflect the changes
   - Update the "Last Updated" timestamp
   - Add a note about what was updated

### Deep Verification (run for ALL existing docs, not just changed ones)

For each existing doc, perform these spot-checks even if no git changes were detected. These catch pre-existing inaccuracies that the initial generation may have introduced:

#### 5a. Code Snippet Spot-Check
   - Pick 2-3 code snippets from the doc
   - Read the actual source file and verify the snippet is verbatim (not simplified)
   - If simplified: flag for update

#### 5b. Schema Spot-Check
   - Pick the main model's table
   - Read its columns from `db/schema.rb`
   - Compare column count with the doc's schema table
   - If the doc has fewer columns: flag for update

#### 5c. Policy Completeness Check
   - Read the actual policy file
   - Count methods in the file vs methods documented
   - If the doc has fewer: flag for update

#### 5d. Model Concerns Check
   - Read the main model file's first 20 lines
   - Check all `include` statements are documented
   - If any concern is missing: flag for update

#### 5e. Route vs Action Check
   - For 2-3 routes listed in the doc, verify the controller action exists
   - If a route has no action: flag for update

#### 5f. Feature Status Check
   - Verify the controller file exists
   - If marked "Active" but controller/views are missing: flag for update

#### 5g. Known Issues Check
   - Scan for methods that return hardcoded values (e.g., `def method; false; end`)
   - Scan for commented-out code in key service/model files
   - Check if the doc has a "Known Issues" section capturing these

If no changes AND no spot-check issues found: **Skip** — document is current.

### If documentation DOES NOT EXIST:
1. Add it to the generation queue

## Step 3: Generate Missing Documentation

Process features in priority order. For each feature:

1. Read the feature's entry in `docs/features/catalog.md` to understand scope and subfeatures
2. Use the **Key paths** listed in the catalog to find all related files
3. Read the key files to extract real code examples, patterns, and architecture
4. Generate `docs/features/<namespace>/<feature-name>.md` following the feature template (use the Namespace Mapping above to determine the correct directory; create the directory if it doesn't exist)
5. Follow ALL verification steps from the `generate-feature-doc` command (4a through 4h)
6. Include: Overview, Architecture, Model Details, Components table, Database Schema, API endpoints, Authorization, Usage Examples, Known Issues, Testing, Performance, Troubleshooting, Related Features

### Priority Order

#### Priority 1 — Core Business (backoffice features 1-8)
`backoffice/authentication`, `backoffice/product-catalog`, `backoffice/sales-orders`, `backoffice/fulfillment`, `backoffice/purchase-orders`, `backoffice/customer-management`, `backoffice/company-management`, `backoffice/supplier-management`

#### Priority 2 — Operations & Integrations (backoffice features 9-13)
`backoffice/payment-processing`, `backoffice/shopify-integration`, `backoffice/shipping`, `backoffice/carts`

#### Priority 3 — POS (10 sub-feature docs)
`pos/authentication`, `pos/terminals-setup`, `pos/sessions-registers`, `pos/cart-management`, `pos/product-search`, `pos/customers`, `pos/payments`, `pos/receipts-printing`, `pos/fulfillment`, `pos/realtime-hardware`

#### Priority 4 — APIs (8 sub-feature docs)
`apis/authentication`, `apis/products`, `apis/orders`, `apis/customers`, `apis/carts-checkout`, `apis/inventory`, `apis/catalog`, `apis/infrastructure`

#### Priority 5 — Supporting Features
`backoffice/reporting`, `backoffice/user-account-management`, `backoffice/account-settings`, `backoffice/printing`, `backoffice/import-export`, `backoffice/activity-collaboration`, `backoffice/integrations`, `landing-pages`, `platform-infrastructure`

#### Already Documented (all 41 doc files)
All features have initial documentation generated across namespaced directories. This command will detect code changes since last generation, run deep verification spot-checks, and update as needed.

## Step 4: Update the Index

After all documentation is generated/updated:
1. Update `docs/README.md` — change status from "⬜ Pending" to "✅ Complete" and add file links
2. Update the "Last Updated" date at the top

## Step 5: Summary Report

Show a summary of what was done:
```
Documentation Update Summary
=============================
New features discovered:  X features (list which ones — added to catalog + generated docs)
Mappings updated:         X features (list which ones — added unmapped files to YAML)
Updated (code changes):   X features (list which ones and what changed)
Updated (spot-check):     X features (list which ones and what was inaccurate)
Generated:                X features (list which ones)
Skipped:                  X features (no changes, spot-checks passed)
Total:                    N feature docs (backoffice + POS + APIs + root)
```

## Quality Standards

- **Verbatim code only** — never simplify or paraphrase code snippets
- **Complete schema** — ALL columns from `db/schema.rb`, not a subset
- **Complete policies** — ALL policy methods, not just CRUD
- **Complete models** — ALL concerns, associations (with dependent: options), callbacks
- **Verified routes** — every route has a matching controller action (or is flagged)
- **Accurate status** — only mark "Active" if controller + views + routes all exist
- **Known issues documented** — no-ops, dead code, hardcoded values, potential bugs
- Real code examples from the codebase
- Mermaid diagrams for complex architectural flows
- "Generated: YYYY-MM-DDTHH:MM:SSZ" and "Last Updated: YYYY-MM-DDTHH:MM:SSZ" timestamps on all files (ISO 8601 datetime)
- Cross-reference related feature docs
- Correct versions: Rails 8.1.0, Ruby 4.0.1

## Common Mistakes to Avoid

These are the most frequent documentation errors found in previous reviews:

1. **Simplified code snippets** — showing `user.valid_auth_code?(code)` when the actual code has a demo bypass check before it
2. **Fabricated method names** — referencing `update_source_line_item` that doesn't exist anywhere in the codebase
3. **Missing concerns** — documenting a model but forgetting `Assignable`, `Payable`, `Shippable`, `Trackable`, etc.
4. **Partial policy lists** — listing 4 policy methods when the file has 12
5. **Phantom routes** — listing `DELETE /resource/:id` when `routes.rb` only defines `index/show/create/update`
6. **Wrong file paths** — saying a form object is in `app/forms/` when it's actually in `app/models/`
7. **Omitted dependent options** — writing `has_many :items` when the actual code says `has_many :items, dependent: :destroy`
8. **Cherry-picked schema columns** — listing 8 columns when the table has 20
9. **Active status for unimplemented features** — routes exist but no controller or views
10. **Ignoring no-op methods** — not flagging that `requires_upgrade?` always returns `false`

## Important Notes

- **Isolation**: Each feature doc is self-contained in its own file. Only update the specific feature file that changed — never modify unrelated feature docs.
- **Deep verification is essential**: Even when `git log` shows no changes, the doc may have pre-existing inaccuracies from initial generation. The spot-checks catch these.
- Work through features ONE AT A TIME to maintain quality
- After generating/updating each feature doc, briefly verify it looks correct before moving to the next
- If the context window is getting large, prioritize completing the current feature and provide a summary of remaining work
