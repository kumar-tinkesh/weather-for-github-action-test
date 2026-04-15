# Project Instructions for Claude

These instructions apply to every Claude Code session in this project.

## Coding Standards

- Follow existing patterns in the codebase — don't introduce new architectural patterns without discussion
- All user-facing queries must be scoped to `current_account` (multi-tenancy)
- Use Pundit for authorization in controllers (`authorize @resource`)
- Use service objects for complex business logic, not fat models or controllers
- Prefer Turbo Frames/Streams over full page reloads
- Use ViewComponent for reusable UI components

## Testing

- Write RSpec tests for new code
- Use FactoryBot for test data
- Use VCR cassettes for external API calls
- Run `bundle exec rspec` to verify changes

## Documentation Generation

This project uses Claude Code custom commands to generate documentation:
- `/app-docs` — Generates `docs/app.md`
- `/config-docs` — Generates `docs/config.md`
- `/generate-feature-doc` — Generates individual feature docs in `docs/features/<namespace>/` (backoffice, pos, apis, or root)

When generating documentation:
- Always analyze actual code — never assume or use placeholders
- Include real code examples from the codebase
- Use correct versions: Rails 8.1.0, Ruby 4.0.1
- Add Mermaid diagrams for complex flows
- Include timestamps on generated files
- Follow templates in `.claude/prompts/templates/`
