---
description: Generate an API Reference doc for a specific API feature. Usage: /generate-api-doc <feature-name>
---

You are tasked with generating a customer-facing API Reference document for a Skutally API feature. API docs help integrators understand and use Skutally's API — they include endpoints, parameters, request/response examples, and code samples.

## Instructions

1. **Read the feature catalog** at `docs/features/catalog.md` — find the APIs entry (#20) and locate the sub-feature for: `$ARGUMENTS`

2. **Read the corresponding technical API doc** at `docs/features/apis/<slug>.md` — this is your primary source

3. **Read the API doc template** at `.claude/prompts/templates/api-doc.template.md`

4. **Read the GraphQL schema/types** for the feature:
   - Look in `app/graphql/types/` for the relevant type definitions
   - Look in `app/graphql/mutations/` for mutation definitions
   - Look in `app/graphql/queries/` or `app/graphql/resolvers/` for query definitions
   - Check `app/graphql/input_types/` for input type definitions

5. **Read authentication logic**:
   - API authentication mechanism (token, OAuth, etc.)
   - How tokens are generated and validated
   - Per-endpoint permission requirements

6. **Generate the API reference** following the template:
   - Complete request/response examples with realistic fake data
   - All parameters documented with types, required/optional, descriptions
   - Error codes and their meanings
   - Code examples in JavaScript and at least one other language (Python or Ruby)
   - Use API field names, NOT internal model/column names

7. **Save the output** to `docs/api-docs/<slug>.md`
   - Create the directory if it doesn't exist

8. **Remove the "Content Rules" section** from the generated output

## Quality Standards

- **Complete endpoint coverage** — every query/mutation/endpoint documented
- **Realistic examples** — use plausible fake data, not "string" or "example"
- **Accurate parameter types** — derived from GraphQL schema or controller params
- **Working code examples** — syntactically correct in each language
- **Error documentation** — common error responses with causes and solutions
- **No internal details** — use API field names, not database column names or model attributes

## Common Mistakes to Avoid

1. **Using internal names** — showing `sales_order_id` when the API exposes `orderId`
2. **Missing required fields** — not marking which parameters are mandatory
3. **Incomplete responses** — only showing 2 fields when the API returns 15
4. **Wrong field types** — saying a field is a String when the GraphQL type is an ID
5. **No error examples** — only showing success responses
6. **Broken code examples** — syntax errors in JavaScript/Python examples

Begin by reading the catalog and technical API doc for this feature, then read the GraphQL schema and generate the API reference.
