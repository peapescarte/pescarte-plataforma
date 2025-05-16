# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
The PEA Pescarte platform is a web application built with Elixir, Phoenix, and LiveView. It serves as a digital platform for the PEA Pescarte project, focusing on artisanal fishing communities.

## Technology Stack
- **Backend**: Elixir/Phoenix
- **Frontend**: Phoenix LiveView, TailwindCSS
- **Database**: PostgreSQL via Ecto
- **Authentication**: Supabase
- **API**: GraphQL with Absinthe

## Environment Setup

The project supports three development environment options:
1. Docker (recommended for most developers)
2. Nix
3. asdf

For all setup options, first install [supabase-cli](https://supabase.com/docs/guides/cli/getting-started#installing-the-supabase-cli) and login:
```sh
supabase login
```

### Docker Setup
Requirements:
- Docker 24.0.8+
- docker-compose 2.19.0+
- supabase-cli >= 1.122.0

Setup steps:
```sh
# Build containers
docker compose build

# Start Supabase services
supabase start

# Start the application
docker compose up
```

## Common Commands

### Development
```sh
# Run development server (compiles assets, sets up DB, starts Phoenix)
mix dev

# Setup environment (installs git hooks, gets deps, sets up DB, seeds data)
mix setup

# Build assets
mix assets.build

# Deploy assets (for production)
mix assets.deploy
```

### Database
```sh
# Create and migrate database
mix ecto.setup

# Reset database (drop, create, migrate)
mix ecto.reset

# Run migrations
mix ecto.migrate

# Rollback migrations
mix ecto.rollback

# Run database seeding
mix seed
```

### Testing
```sh
# Run all tests
mix test

# Run only unit tests
mix test --only unit

# Run only integration tests
mix test --only integration
```

### Code Quality
```sh
# Run linting checks (compile with warnings as errors, format check, credo)
mix lint

# Run CI checks (lint + tests)
mix ci.check
```

## Directory Structure

- `/lib/pescarte` - Core business logic and domain models
  - `/application.ex` - Application entry point
  - `/database.ex` - Database abstraction
  - `/domains/` - Business domains (contexts)

- `/lib/pescarte_web` - Web layer
  - `/controllers` - Request handlers for traditional Phoenix views
  - `/design_system` - UI components implementing design system
  - `/graphql` - GraphQL API using Absinthe
  - `/live` - LiveView components for real-time, interactive pages
  - `/templates` - HTML templates

- `/assets` - Frontend assets
  - `/css` - SCSS files for styling
  - `/js` - JavaScript modules
  
- `/priv` - Private application data
  - `/repo/migrations` - Database migrations

- `/test` - Test files

## Architecture Overview

The application follows a clean/explicit architecture pattern with these layers:

1. **Models** - Core domain entities, cannot be accessed directly by other domains
2. **Services** - Pure functions that modify domain models
3. **Handlers** - Public API for domains, the only way to communicate with domains
4. **Repository** - CRUD operations for domain entities

The application is modular with separate domains like:
- `modulo_pesquisa` - Research module
- `blog` - Blog functionality
- `catalogo` - Catalog functionality
- `cotacoes` - Quotes functionality
- `identidades` - User identity management

## Development Workflow

1. Create a branch following the format: `<github-username>/<task-description>`
2. Implement the feature or fix the bug
3. Open a PR to the `main` branch
4. Make any requested changes from code review

## Testing Approach

Tests are tagged with either `:unit` or `:integration` module tags:

```elixir
defmodule Pescarte.UnitTests do
  @moduletag :unit
  
  # test code
end
```

```elixir
defmodule Pescarte.IntegrationTests do
  @moduletag :integration
  
  # test code
end
```

To run specific test types:
```sh
mix test --only unit
mix test --only integration
```