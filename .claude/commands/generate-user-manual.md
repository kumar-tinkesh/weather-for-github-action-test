---
description: Generate a User Manual for a specific feature. Usage: /generate-user-manual <feature-name>
---

You are tasked with generating a step-by-step User Manual for a Skutally feature. User manuals provide click-by-click UI instructions — they answer "how do I?" questions for end users (back-office operators, POS staff).

## Namespace Mapping

| Namespace | Manual Directory | Features |
|-----------|-----------------|----------|
| Back-office | `docs/user-manuals/backoffice/` | authentication, product-catalog, inventory-management, sales-orders, fulfillment, purchase-orders, customer-management, company-management, supplier-management, payment-processing, shipping, carts, reporting, user-account-management, account-settings, dynamic-search, printing, import-export, activity-collaboration, shopify-integration, integrations |
| POS | `docs/user-manuals/pos/` | authentication, terminals-setup, sessions-registers, cart-management, product-search, customers, payments, receipts-printing, fulfillment, realtime-hardware |

**Note:** API features do not get user manuals — they get API reference docs instead.

## Instructions

1. **Read the feature catalog** at `docs/features/catalog.md` — find the entry for: `$ARGUMENTS`

2. **Read the corresponding technical doc** — for understanding the feature's capabilities:
   - Backoffice: `docs/features/backoffice/<slug>.md`
   - POS: `docs/features/pos/<slug>.md`

3. **Read the user manual template** at `.claude/prompts/templates/user-manual.template.md`

4. **Read ERB view templates** to extract exact UI details:
   - **Button labels**: Look for `link_to`, `button_to`, `submit_tag`, `button_tag` text in view files
   - **Form fields**: Look for `f.input`, `f.text_field`, `f.select`, label text in `_form.html.erb` partials
   - **Menu/navigation paths**: Look at sidebar/nav partials and layout files
   - **Tab names**: Look for tab/nav components in the views
   - **Flash messages**: Look for `flash[:notice]`, `flash[:alert]`, `flash[:error]` in controllers
   - **Table columns**: Look at index view templates for column headers
   - **Modal dialogs**: Look for modal components and their trigger buttons

5. **Read Pundit policies** to translate permissions to plain language:
   - `manage_orders?` → "Manage Orders permission"
   - `view_reports?` → "View Reports permission"

6. **Read controller actions** to understand workflow sequences:
   - What happens when each action completes (redirects, flash messages)
   - What validations block submission
   - What side effects occur (emails sent, status changes)

7. **Generate the user manual** following the template:
   - Use **bold** for all UI elements (button names, field labels, menu items)
   - Write in second person ("You", "Click", "Navigate to")
   - One action per numbered step
   - Include "Expected Result" after each task section
   - Cover the primary workflow first, then variations and edge cases
   - Include a Troubleshooting section with common issues

8. **Save the output** to the correct path:
   - Backoffice: `docs/user-manuals/backoffice/<slug>.md`
   - POS: `docs/user-manuals/pos/<slug>.md`
   - Create the directory if it doesn't exist

9. **Remove the "Content Rules" section** from the generated output

## Quality Standards

- **Exact UI labels** — button text must match what's in the ERB templates
- **Complete workflows** — cover the full user journey, not just the happy path
- **Accurate navigation paths** — verify menu structure from layout/sidebar templates
- **Permission callouts** — tell users what permissions they need before starting
- **Troubleshooting section** — minimum 3 common issues per feature
- **No technical content** — no code, schema, architecture details

## Common Mistakes to Avoid

1. **Guessing button labels** — always verify against the actual ERB template
2. **Missing prerequisites** — forgetting to mention required permissions or setup
3. **Skipping error states** — not explaining what happens when validation fails
4. **Wrong navigation paths** — assuming a menu structure without checking the layout
5. **Too many steps per task** — break complex workflows into separate task sections
6. **Using developer language** — "submit a POST request" instead of "click Save"
7. **Missing variations** — only documenting the default workflow, not bulk operations, imports, etc.

Begin by reading the catalog and technical doc for this feature, then read the relevant view templates and generate the user manual.
