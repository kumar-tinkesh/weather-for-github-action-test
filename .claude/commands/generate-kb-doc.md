---
description: Generate a Knowledge Base doc for a specific feature. Usage: /generate-kb-doc <feature-name>
---

You are tasked with generating a customer-facing Knowledge Base document for a Skutally feature. KB docs explain features conceptually — what they do, business logic, capabilities, FAQs — without exposing any technical internals.

## Namespace Mapping

| Namespace | KB Directory | Features |
|-----------|-------------|----------|
| Back-office | `docs/knowledge-base/backoffice/` | authentication, product-catalog, inventory-management, sales-orders, fulfillment, purchase-orders, customer-management, company-management, supplier-management, payment-processing, shipping, carts, reporting, user-account-management, account-settings, dynamic-search, printing, import-export, activity-collaboration, shopify-integration, integrations |
| POS | `docs/knowledge-base/pos/` | authentication, terminals-setup, sessions-registers, cart-management, product-search, customers, payments, receipts-printing, fulfillment, realtime-hardware |
| APIs | `docs/knowledge-base/apis/` | products, orders, customers, carts-checkout, inventory, catalog, infrastructure |

## Instructions

1. **Read the feature catalog** at `docs/features/catalog.md` — find the entry for: `$ARGUMENTS`

2. **Read the corresponding technical doc** — this is your PRIMARY source:
   - Backoffice: `docs/features/backoffice/<slug>.md`
   - POS: `docs/features/pos/<slug>.md`
   - APIs: `docs/features/apis/<slug>.md`
   - Root: `docs/features/<slug>.md`

3. **Read the KB template** at `.claude/prompts/templates/knowledge-base.template.md`

4. **Selectively read code** for customer-visible behavior:
   - ERB view templates — for UI states, labels, flash messages visible to users
   - AASM state machines — for lifecycle stages (translate to plain language)
   - Pundit policies — translate permission methods to plain-language descriptions
   - Do NOT include any code in the output

5. **Transform the technical doc into KB format**:
   - Replace all technical terms with business terms
   - Remove ALL code snippets, schema details, file paths, class names
   - Explain state machines as business workflows
   - Translate permission names to plain language ("You need permission to manage orders")
   - Focus on WHAT and WHY, not HOW (technically)
   - Write FAQ questions that real customers would ask

6. **Save the output** to the correct path:
   - Backoffice: `docs/knowledge-base/backoffice/<slug>.md`
   - POS: `docs/knowledge-base/pos/<slug>.md`
   - APIs: `docs/knowledge-base/apis/<slug>.md`
   - Create the directory if it doesn't exist

7. **Remove the "Content Rules" section** from the generated output — it's for your reference only

## Quality Standards

- **Zero technical content** — no code, schema, file paths, model names, controller names
- **Customer-friendly language** — explain as if talking to a non-technical business user
- **Accurate business logic** — derived from actual code behavior, not assumptions
- **Complete FAQ section** — minimum 5 Q&A pairs per feature
- **Cross-references** — link to related KB docs using plain feature names
- **No fabricated capabilities** — only document what the code actually supports

## Common Mistakes to Avoid

1. **Leaking technical terms** — writing "the AASM state machine transitions to shipped" instead of "the order moves to Shipped status"
2. **Including code** — even pseudocode is not allowed
3. **Using model names** — "SalesOrder" should be "sales order" or "order"
4. **Mentioning file paths** — never reference `app/controllers/` etc.
5. **Fabricating features** — don't describe capabilities that don't exist in the code
6. **Skipping the FAQ** — this is the most valuable section for the AI chatbot
7. **Being too vague** — "You can manage orders" is less useful than "You can create, edit, duplicate, void, and archive orders"

Begin by reading the catalog and technical doc for this feature, then generate the KB document.
