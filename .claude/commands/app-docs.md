---
description: Analyze the app directory and generate comprehensive documentation
---

You are tasked with analyzing the Skutally Rails application's `app/` directory and generating comprehensive documentation. The project uses **Rails 8.1.0** and **Ruby 4.0.1**. Follow these steps systematically:

## Step 1: Inventory and Categorization

First, scan the app directory structure and categorize all components:

1. **Models**: All files in app/models/ including concerns
2. **Controllers**: All files in app/controllers/ including concerns
3. **Views**: Template organization in app/views/
4. **Services**: Business logic in app/services/
5. **Jobs**: Background workers in lib/workers/
6. **Mailers**: Email functionality in app/mailers/
7. **Helpers**: View helpers in app/helpers/
8. **Channels**: ActionCable channels in app/channels/
9. **Serializers/Presenters**: Data formatting classes
10. **Policies**: Authorization policies (if using Pundit)
11. **Decorators**: Object decorators (if using Draper or similar)
12. **Other Directories**: Any custom directories

## Step 2: Analysis Requirements

For each component category, analyze and document:

### For Models (app/models/):
- **Model Name**: Class name and table name
- **Purpose**: What domain concept does this model represent?
- **Associations**: belongs_to, has_many, has_one, has_and_belongs_to_many
- **Validations**: Required fields, format validations, custom validations
- **Scopes**: Named scopes and their purposes
- **Callbacks**: before_save, after_create, etc.
- **Class Methods**: Important class-level methods
- **Instance Methods**: Key instance methods and their purposes
- **Concerns**: Included modules and their functionality
- **Database Columns**: Key attributes (from schema if needed)
- **Business Logic**: Important model-specific logic
- **External Integrations**: APIs or services the model interacts with

### For Controllers (app/controllers/):
- **Controller Name**: Class name and resource it manages
- **Purpose**: What user actions does it handle?
- **Actions**: List all actions (index, show, create, update, destroy, custom)
- **Before Actions**: Filters and callbacks
- **Authorization**: How access control is implemented
- **Parameters**: Strong parameters and their structure
- **Response Formats**: JSON, HTML, etc.
- **Concerns**: Included controller concerns
- **API Endpoints**: If it's an API controller, document the endpoints

### For Services (app/services/):
- **Service Name**: Class name
- **Purpose**: What business operation does it perform?
- **Public Interface**: Main methods and their signatures
- **Dependencies**: Models, external APIs, or other services it uses
- **Error Handling**: How errors are handled and communicated
- **Return Values**: What the service returns
- **Usage Examples**: Where and how it's called in the application

### For Workers (lib/workers/):
- **Job Name**: Class name
- **Purpose**: What background task does it perform?
- **Queue**: Which queue it runs on
- **Schedule**: If it's a scheduled job, when does it run?
- **Parameters**: What arguments it accepts
- **Error Handling**: Retry logic, failure handling
- **Dependencies**: External services or APIs it uses
- **Performance**: Expected runtime, frequency

### For Mailers (app/mailers/):
- **Mailer Name**: Class name
- **Purpose**: What emails does it send?
- **Actions**: Email methods and their purposes
- **Parameters**: What data is passed to emails
- **Templates**: Associated view templates
- **Attachments**: If any attachments are included
- **Recipients**: How recipients are determined

### For Views (app/views/):
- **Directory Structure**: Organization by controller/resource
- **Layout Files**: Application layouts
- **Partials**: Reusable view components
- **View Formats**: HTML, JSON, etc.
- **Frontend Dependencies**: JavaScript, CSS frameworks used

### For Helpers (app/helpers/):
- **Helper Name**: Module name
- **Purpose**: What view logic does it provide?
- **Methods**: Available helper methods
- **Usage**: Where these helpers are commonly used

### For Concerns:
- **Concern Name**: Module name
- **Purpose**: What shared functionality does it provide?
- **Methods**: Public methods available
- **Usage**: Which models/controllers include it
- **Dependencies**: What it depends on

## Step 3: Documentation Format

Generate documentation in the following markdown structure:

```markdown
# App Directory Documentation

## Overview
Brief description of the application's architecture and organization.

## Architecture Summary
- **Total Models**: [count]
- **Total Controllers**: [count]
- **Total Services**: [count]
- **Total Jobs**: [count]
- **Key Patterns**: [e.g., Service Objects, Concerns, Decorators]

## Models

### Core Domain Models
Document primary business entities (e.g., User, Product, Order)

For each model:
#### ModelName (`app/models/model_name.rb`)
- **Purpose**: [What it represents]
- **Key Associations**:
  - belongs_to :association
  - has_many :associations
- **Important Validations**: [Required fields, formats]
- **Key Methods**: [Important business logic methods]
- **Integrations**: [External services if any]

### Supporting Models
Document secondary models, join tables, etc.

### Model Concerns
Document shared model functionality

## Controllers

### Main Controllers
Document primary user-facing controllers

For each controller:
#### ControllerName (`app/controllers/controller_name.rb`)
- **Purpose**: [What it manages]
- **Actions**: [index, show, create, update, destroy, custom actions]
- **Authentication/Authorization**: [How access is controlled]
- **Key Endpoints**: [Important routes]

### API Controllers
Document API-specific controllers if separate

### Controller Concerns
Document shared controller functionality

## Services

### Business Logic Services
Document core business operations

For each service:
#### ServiceName (`app/services/service_name.rb`)
- **Purpose**: [What operation it performs]
- **Interface**: `ServiceName.call(params)` or similar
- **Use Cases**: [Where it's used]
- **External Dependencies**: [APIs, third-party services]

### Integration Services
Document external service integrations

### Utility Services
Document helper/utility services

## Background Jobs

### Scheduled Jobs
Document recurring/scheduled jobs

For each job:
#### WorkerName (`lib/workers/namespace/worker_name.rb`)
- **Purpose**: [What it does]
- **Schedule**: [When it runs]
- **Queue**: [Queue name]
- **Dependencies**: [What it needs]

### Event-Driven Jobs
Document jobs triggered by application events

## Mailers

For each mailer:
#### MailerName (`app/mailers/mailer_name.rb`)
- **Purpose**: [What emails it sends]
- **Methods**: [Email actions]
- **Templates**: [Associated views]

## Views

### Layout Structure
Document application layouts and common UI patterns

### Key View Directories
Document major view sections

### Partials & Components
Document reusable view components

## Helpers

Document view helpers and their purposes

## Policies/Authorization

Document authorization logic (if using Pundit or similar)

## Data Flow Diagrams

### Key User Flows
Document important user journeys through the application:
1. User Registration/Authentication Flow
2. Main Business Process Flows
3. Payment/Transaction Flows (if applicable)

### Service Integration Patterns
Document how services interact with models and controllers

## Technical Debt & Improvement Opportunities

- **Code Smells**: Fat models, large controllers, long methods
- **Missing Tests**: Areas lacking test coverage
- **Deprecated Patterns**: Old code patterns that need updating
- **Performance Concerns**: N+1 queries, missing indexes, slow operations
- **Duplication**: Repeated code that could be extracted

## Dependencies & Integrations

### External Services
List all external APIs and services integrated in the app layer:
- Service name
- Where it's used (models, services, jobs)
- Authentication method
- Key endpoints used

### Third-Party Gems
Key gems that affect application structure:
- Devise, Pundit, Draper, etc.
- How they're used in the app layer

## Conventions & Patterns

### Naming Conventions
Document how classes, methods, and files are named

### Code Organization Patterns
Document architectural patterns used:
- Service objects pattern
- Form objects
- Query objects
- Decorators/Presenters
- Concerns usage

### Testing Approach
Document testing patterns in the codebase

## Onboarding Guide

### Key Entry Points
Where new developers should start:
- Main models to understand
- Important controllers
- Critical services

### Common Tasks
Where to make common changes:
- Adding a new model
- Adding a new API endpoint
- Adding a background job
- Sending a new email

## Glossary

Define domain-specific terms and business concepts used in the codebase.
```

## Step 4: Special Considerations

- **Complexity Hotspots**: Identify particularly complex classes that need refactoring
- **Security**: Note authentication, authorization, and data validation patterns
- **Performance**: Identify potential performance bottlenecks (N+1 queries, large loops)
- **Dependencies**: Map dependencies between services, models, and controllers
- **Test Coverage**: Note which components have good test coverage vs. which don't
- **Dead Code**: Identify unused models, controllers, or services
- **Coupling**: Note tightly coupled components that could benefit from refactoring

## Step 5: Analysis Approach

1. Start with a broad overview using Glob to map out directory structure
2. Read key files to understand the application's domain
3. Identify patterns and conventions used consistently
4. Document core business entities first (models)
5. Then document how users interact with them (controllers)
6. Then document complex business logic (services)
7. Finally document supporting components (jobs, mailers, helpers)

## Step 6: Output

Generate a comprehensive markdown document and save it as `docs/app.md`.

**Important:**
- Use correct versions: Rails 8.1.0, Ruby 4.0.1
- Include a "Generated: YYYY-MM-DDTHH:MM:SSZ" timestamp at the top (ISO 8601 datetime)
- Only include information derived from actual code analysis — no placeholders
- Reference the feature template at `.claude/prompts/templates/feature.template.md` for documentation standards

Begin your analysis now by reading and documenting the app directory systematically.
