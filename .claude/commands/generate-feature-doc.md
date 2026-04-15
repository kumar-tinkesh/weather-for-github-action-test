---
description: Generate documentation for a specific feature. Usage: /generate-feature-doc <feature-name>
---

You are tasked with generating comprehensive documentation for a specific feature of the Skutally Rails application (Rails 8.1.0, Ruby 4.0.1).

## Namespace Mapping

Features are organized into namespace directories. Features not in a namespace stay at root (`docs/features/`).

| Namespace | Directory | Features |
|-----------|-----------|----------|
| Back-office | `docs/features/backoffice/` | authentication, product-catalog, inventory-management, sales-orders, fulfillment, purchase-orders, customer-management, company-management, supplier-management, payment-processing, shipping, carts, reporting, user-account-management, account-settings, dynamic-search, printing, import-export, activity-collaboration, shopify-integration, integrations |
| POS | `docs/features/pos/` | authentication, terminals-setup, sessions-registers, cart-management, product-search, customers, payments, receipts-printing, fulfillment, realtime-hardware |
| APIs | `docs/features/apis/` | authentication, products, orders, customers, carts-checkout, inventory, catalog, infrastructure |
| Root | `docs/features/` | landing-pages, platform-infrastructure |

**Note:** POS and APIs namespaces have multiple feature docs (not a single monolithic file). Each sub-feature has its own file, with a `README.md` serving as the namespace index.

## Instructions

1. **Read the feature catalog** at `docs/features/catalog.md` — find the entry for: `$ARGUMENTS`
   - For backoffice/root features: find the feature entry directly (e.g., `authentication`, `sales-orders`)
   - For POS sub-features: find the POS parent entry (#11) and use the sub-feature table + **Key paths** for the specific slug (e.g., `pos/payments`)
   - For API sub-features: find the APIs parent entry (#20) and use the sub-feature table + **Key paths** for the specific slug (e.g., `apis/products`)
   - The Feature-to-Path Mapping (YAML) at the bottom of catalog.md has per-sub-feature key paths
2. **Determine the namespace** — use the Namespace Mapping table above to find the correct directory for this feature
3. **Read the feature template** at `.claude/prompts/templates/feature.template.md`
4. **Analyze the relevant code** — use the Key paths from the catalog as your starting point, then perform ALL of the following checks:

### 4a. Core File Analysis
   - Controllers (read the full file, note ALL actions)
   - Models (read the full file, note ALL associations, concerns, callbacks, validations, methods)
   - Services (`app/services/`)
   - Workers/Jobs (`lib/workers/`)
   - Policies (`app/policies/` — read the full file, list ALL methods)
   - Search classes (`app/searches/`)
   - JavaScript/Stimulus (`app/javascript/`)
   - Components (`app/components/`)
   - Broadcasters (`app/broadcasters/`)
   - Tests (`spec/`)
   - Routes (`config/routes.rb`)
   - Configuration files

### 4b. Schema Verification (MANDATORY)
   - Read `db/schema.rb` for EVERY table referenced by the feature's models
   - List ALL columns — do not cherry-pick or summarize
   - Verify column defaults match what the code expects
   - Note any columns the model references that don't exist in the schema (flag as "Known Issue")

### 4c. Route Verification (MANDATORY)
   For every route you plan to document:
   - Verify the controller action method EXISTS in the controller file
   - If a route exists but the action does not, mark it as "⚠️ Route only — no action"
   - If a controller action exists but has no route, note it as "⚠️ Action without route"

### 4d. Model Completeness (MANDATORY)
   For each model:
   - List ALL `include` statements (concerns like Assignable, Trackable, Payable, Shippable, Contactable, Receivable, etc.)
   - List ALL associations with their full options (`dependent:`, `optional:`, `class_name:`, `foreign_key:`, `as:`)
   - List ALL callbacks in order (`before_validation`, `before_save`, `after_create`, `after_commit`, etc.)
   - List ALL state machine definitions (AASM or state_machine) with complete transition rules
   - Note any methods that are no-ops, always return fixed values, or have commented-out code

### 4e. Policy Completeness (MANDATORY)
   - Read the FULL policy file
   - List ALL public methods (not just CRUD — include `select_address?`, `manage_assignments?`, `self_assign?`, custom methods, etc.)
   - Note any methods that always return true/false regardless of conditions
   - Note delegation chains (e.g., `destroy?` delegates to `update?`)

### 4f. Code Snippet Integrity (MANDATORY)
   - EVERY code snippet in the doc MUST be a verbatim copy from the source file
   - NEVER simplify, summarize, or paraphrase code
   - Include the source file path and line number as a comment above snippets
   - If a method is too long, show key sections with `# ...` but NEVER change logic or remove conditional branches
   - NEVER invent method names — if you reference a method, verify it exists first

### 4g. Feature Status Verification (MANDATORY)
   Before setting the Status field:
   - ✅ Active: Controller file exists AND has action methods AND views exist AND routes exist
   - ⚠️ Beta: Feature works but is behind a feature flag or has known limitations
   - ⚠️ Planned / Routes Only: Routes exist but controller/views are missing
   - 🚫 Deprecated: Feature is being phased out

### 4h. Known Issues & Caveats (MANDATORY)
   Actively search for and document:
   - Methods that always return a fixed value (no-ops like `requires_upgrade?` → `false`)
   - Commented-out API calls or feature code
   - Hardcoded values that look like test/dev data (emails, account numbers, dates)
   - Model associations where the DB column doesn't exist
   - Routes without controller actions (dead routes)
   - Policy methods that always return true (bypassed permissions)
   - Copy-paste bugs (methods with identical implementations that should differ)
   - Security-relevant backdoors (demo accounts, hardcoded credentials)

5. **Generate the documentation** following the feature template structure. Ensure you include:
   - Overview (what it does, why it exists, key capabilities)
   - Architecture (high-level design with Mermaid diagrams)
   - Model Details (ALL associations, concerns, callbacks — see template)
   - Components table (backend and frontend with actual file paths)
   - Database schema (from `db/schema.rb` — ALL columns for each table)
   - API endpoints (from routes — verified against controller actions)
   - Authorization (ALL policy methods)
   - Configuration (environment variables, config files)
   - Usage examples (VERBATIM code from the codebase)
   - Known Issues & Caveats
   - Testing (actual test files and approach)
   - Performance considerations
   - Troubleshooting (common issues)
   - Related features

6. **Save the output** to the correct path based on namespace:
   - Backoffice features: `docs/features/backoffice/<feature-name>.md`
   - POS features: `docs/features/pos/<feature-name>.md`
   - API features: `docs/features/apis/<feature-name>.md`
   - All others: `docs/features/<feature-name>.md`
   - Example: `docs/features/backoffice/sales-orders.md`, `docs/features/pos/payments.md`, `docs/features/apis/products.md`, `docs/features/landing-pages.md`
   - **Only write this one feature file** — do not modify other feature docs
7. **Update `docs/README.md`** — change this feature's status from "⬜ Pending" to "✅ Complete" and add the file link

## Quality Standards

- **Verbatim code only** — never simplify or paraphrase code snippets
- **Complete schema** — ALL columns from `db/schema.rb`, not a subset
- **Complete policies** — ALL policy methods, not just CRUD
- **Complete models** — ALL concerns, associations, callbacks
- **Verified routes** — every route has a matching controller action (or is flagged)
- **Accurate status** — only mark "Active" if controller + views + routes all exist
- **Known issues documented** — no-ops, dead code, hardcoded values, potential bugs
- Include real code examples from the codebase
- Use Mermaid diagrams for complex flows
- Add "Generated: YYYY-MM-DDTHH:MM:SSZ" and "Last Updated: YYYY-MM-DDTHH:MM:SSZ" timestamps (ISO 8601 datetime)
- Cross-reference related feature documentation
- Use correct versions: Rails 8.1.0, Ruby 4.0.1

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

Begin by reading the catalog entry for this feature, then analyze all related files and generate the documentation.
