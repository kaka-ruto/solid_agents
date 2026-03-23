# SolidAgents

**Event-driven error fixing workflow for Rails apps, powered by RubyLLM agents.**

> [!WARNING]
> `solid_agents` is an early release and still a work in progress.
> APIs, schema, runtime behavior, and configuration may change between minor releases.
> Expect breaking changes before `1.0`.
> Not production-ready yet.

`solid_agents` is a Rails engine focused on a single pipeline:

`error received -> staged agent workflow -> code fix attempt -> PR/CI stage tracking`

## Scope

`solid_agents` is for automation orchestration and execution only:

- Consume error-like events from source adapters (starting with `solid_errors` style payloads)
- Track runs in an event-driven stage machine
- Enforce non-overlapping stage ownership (`alex`, `betty`, `chad`, `david`, `eddy`)
- Persist handoffs, notes, and artifacts for each stage
- Execute stage tasks through the RubyLLM runtime adapter

It does **not** own observability storage or incident detection as a source of truth.

## Features

- DB-backed run lifecycle and stage workflow
- Append-only run events with actor attribution
- Work-item board columns driven by stage transitions
- Handoff records between stage owners
- Built-in UI for runs, events, and artifacts
- Installer generator and schema template

## Installation

Add this to your Gemfile:

```ruby
gem "solid_agents"
```

Run installer:

```bash
rails generate solid_agents:install
```

Configure engine DB connection if desired:

```ruby
# config/environments/production.rb
config.solid_agents.connects_to = { database: { writing: :solid_agents } }
config.solid_agents.default_runtime = :ruby_llm
```

Mount the UI:

```ruby
# config/routes.rb
authenticate :user, ->(u) { u.admin? } do
  mount SolidAgents::Engine, at: "/solid_agents"
end
```

## Usage

Create pipeline agents:

```ruby
%w[alex betty chad david eddy].each do |key|
  SolidAgents::Agent.find_or_create_by!(key: key, environment: Rails.env) do |agent|
    agent.name = key.capitalize
    agent.role = key
    agent.runtime = "ruby_llm"
    agent.working_directory = Rails.root.to_s
    agent.enabled = true
  end
end
```

Dispatch from a job:

```ruby
SolidAgents.dispatch_error(source: solid_error_record, agent_key: "alex")
```

## RubyLLM Conventions

- Agent classes live in `app/agents/solid_agents/agents`.
- Prompt instructions live in `app/prompts/.../instructions.txt.erb`.
- Stage owners map directly to RubyLLM agent classes.

## Configuration

```ruby
config.solid_agents.default_model = "gpt-5-nano"
config.solid_agents.default_test_command = "bin/rails test"
config.solid_agents.max_iterations = 8
```

## Development

```bash
bundle install
bundle exec rake test
gem build solid_agents.gemspec
```
