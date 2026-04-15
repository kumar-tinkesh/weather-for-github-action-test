---
description: Analyze the config directory and generate comprehensive documentation
---

You are tasked with analyzing the Skutally Rails application's `config/` directory and generating comprehensive documentation. The project uses **Rails 8.1.0** and **Ruby 4.0.1**. Follow these steps systematically:

## Step 1: Inventory and Categorization

First, scan the config directory structure and categorize all configuration files:

1. **Core Application Files**: application.rb, boot.rb, environment.rb, routes.rb
2. **Environment-Specific Configs**: Files in config/environments/
3. **Service Configurations**: database.yml, redis.yml, cable.yml, storage.yml, etc.
4. **Initializers**: All files in config/initializers/
5. **Localization**: Files in config/locales/
6. **Scheduled Jobs**: schedule.rb, schedule.yml, sidekiq.yml
7. **Frontend Build Tools**: webpack/, webpacker.yml
8. **Other Configuration Files**: Any remaining yml/rb files

## Step 2: Analysis Requirements

For each configuration file or category, analyze and document:

### For Ruby Configuration Files (.rb):
- **Purpose**: What does this file configure?
- **Key Settings**: Important configuration options and their values
- **Dependencies**: External gems, services, or APIs it configures
- **Environment Variables**: Any ENV variables referenced
- **Custom Behavior**: Special logic or conditional configurations
- **Impact**: Which parts of the application are affected

### For YAML Configuration Files (.yml):
- **Purpose**: What service or feature does it configure?
- **Structure**: Key sections and their meanings
- **Environment-Specific Values**: How configs differ per environment
- **Required Keys**: Which settings are mandatory
- **Optional Keys**: Which settings are optional with defaults

### For Initializers:
- **Gem/Library**: What gem or library does it initialize?
- **Configuration Options**: Key settings being configured
- **Execution Order**: If order matters (numbered initializers)
- **Side Effects**: Database access, API calls, or other startup effects

## Step 3: Documentation Format

Generate documentation in the following markdown structure:

```markdown
# Config Directory Documentation

## Overview
Brief description of the application's configuration architecture.

## Configuration Files Index

### Core Application Configuration
- **application.rb**: [Purpose and key settings]
- **boot.rb**: [Purpose and key settings]
- **environment.rb**: [Purpose and key settings]
- **routes.rb**: [Purpose and routing structure]

### Environment-Specific Configuration
Document production.rb, staging.rb, development.rb, test.rb

### Service Configuration
Document database.yml, redis.yml, sidekiq.yml, etc.

### Initializers
Organize by category:
- Authentication & Authorization (devise, pundit, etc.)
- External Services (payment processors, APIs, etc.)
- Performance & Caching
- Development Tools
- Other

### Localization (i18n)
Document locale files and translation structure

### Build & Asset Configuration
Document webpack, webpacker configuration

## Environment Variables Reference
Complete list of ENV variables used across all config files with:
- Variable name
- Purpose
- Default value (if any)
- Required/Optional status
- Which config file(s) use it

## Configuration Checklists

### New Environment Setup
Steps and config files needed for setting up a new environment

### Adding New Services
Which config files to update when adding external services

### Common Configuration Tasks
Frequently modified settings and their locations
```

## Step 4: Special Considerations

- **Security**: Identify any sensitive configurations that should use ENV variables
- **Performance**: Note configs that impact performance (caching, connections, timeouts)
- **Third-Party Services**: List all external services/APIs configured
- **Feature Flags**: Document any feature flag systems (like flipper)
- **Deprecations**: Note any deprecated configurations or patterns

## Step 5: Output

Generate a comprehensive markdown document and save it as `docs/config.md`.

**Important:**
- Use correct versions: Rails 8.1.0, Ruby 4.0.1
- Include a "Generated: YYYY-MM-DDTHH:MM:SSZ" timestamp at the top (ISO 8601 datetime)
- Only include information derived from actual code analysis — no placeholders
- Reference the feature template at `.claude/prompts/templates/feature.template.md` for documentation standards

Begin your analysis now by reading and documenting the config directory systematically.
