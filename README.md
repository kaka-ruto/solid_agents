# SolidAgents

**Automation workflows for Rails apps, powered by agent runtimes.**

> [!WARNING]
> `solid_agents` is an early release and still a work in progress.
> APIs, schema, runtime behavior, and configuration may change between minor releases.
> Expect breaking changes before `1.0`.
> Not production-ready yet.

`solid_agents` is a Rails engine that consumes observability/incident APIs (for example from `solid_events`), stores automation run state, dispatches work to runtime executors (TinyClaw in development, OpenClaw in production), and provides a built-in dashboard for operations.

## Scope

`solid_agents` is strictly for automation and execution:

- Consume incident/trace APIs and operator instructions
- Plan/execute workflows (triage, patch, test, PR, QA, review loops)
- Track run lifecycle, artifacts, and runtime outputs
- Route tasks to runtime adapters (TinyClaw/OpenClaw)

It does **not** own observability storage or incident detection/state as a source of truth. That belongs in `solid_events`.

## Features

- DB-backed run lifecycle (`queued`, `running`, `succeeded`, `failed`)
- Separate agent profiles per environment
- Runtime adapters for TinyClaw and OpenClaw
- Built-in UI for runs, events, artifacts, and agent configuration
- Install generator and schema template aligned with Solid gem conventions

## Installation

Add this to your Gemfile:

```ruby
gem "solid_agents"
```

Run installer:

```bash
rails generate solid_agents:install
```

Add a dedicated database in `config/database.yml` (recommended):

```yaml
production:
  primary: &primary
    <<: *default
    database: app_production
  solid_agents:
    <<: *primary
    database: app_production_solid_agents
    migrations_paths: db/agent_migrate
```

Configure engine DB connection:

```ruby
# config/environments/production.rb
config.solid_agents.connects_to = { database: { writing: :solid_agents } }
config.solid_agents.default_runtime = :openclaw
```

Mount the UI:

```ruby
# config/routes.rb
authenticate :user, ->(u) { u.admin? } do
  mount SolidAgents::Engine, at: "/solid_agents"
end
```

## Usage

Create an agent profile:

```ruby
SolidAgents::Agent.create!(
  key: "fixer",
  name: "Bug Fixer",
  role: "fixer",
  runtime: Rails.env.production? ? "openclaw" : "tinyclaw",
  working_directory: Rails.root.to_s,
  capabilities_json: {"allow_pr" => Rails.env.production?}
)
```

Dispatch from a job:

```ruby
SolidAgents.dispatch_error(source: solid_error_record, agent_key: "fixer")
```

## Configuration

```ruby
config.solid_agents.tinyclaw_command = "tinyclaw"
config.solid_agents.openclaw_command = "openclaw"
config.solid_agents.default_test_command = "bin/rails test"
config.solid_agents.max_iterations = 8
```

## Development

```bash
bundle install
bundle exec rake test
```
