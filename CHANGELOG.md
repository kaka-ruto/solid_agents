# Changelog

All notable changes to `solid_agents` will be documented in this file.

## [v0.2.1] - 2026-03-23

Follow-up release for RubyLLM runtime and path conventions.

- Moved agent classes and prompt templates to `app/solid_agents/agents` and `app/solid_agents/prompts`.
- Added VCR-backed live RubyLLM integration coverage with secret filtering and record-once behavior.
- Standardized LLM credential loading to environment variables only and added `.env.sample`.
- Updated installer and docs to reflect ENV-first configuration and current runtime defaults.

Status notes:

- This release is still WIP and not production-ready.
- Breaking changes are expected before `1.0`.

## [v0.2.0] - 2026-03-23

Major architecture reset delivered as a minor release for rapid iteration.

- Replaced runtime adapters with a single RubyLLM-first execution path.
- Rebuilt the run model into an event-driven staged workflow.
- Added work-item board tracking and explicit inter-agent handoff records.
- Introduced stage ownership with alphabetical agents: alex, betty, chad, david, eddy.
- Updated installer schema and initializer templates for the new workflow primitives.
- Reworked run UI to expose stage, owner, events, and artifacts in clean columns.
- Expanded Minitest coverage and moved to YAML fixtures for deterministic test data.

Status notes:

- This release is still WIP and not production-ready.
- Breaking changes are expected before `1.0`.

## [v0.1.0] - 2026-03-22

Initial public release (WIP).

- Introduced `solid_agents` Rails engine for database-backed agent run orchestration.
- Added run lifecycle models and persistence for runs, events, artifacts, agents, and config.
- Added dispatch and execution flow with runtime adapters for OpenAI RubyLLM runtime and OpenAI RubyLLM runtime.
- Added built-in UI/controllers for managing agents and inspecting runs.
- Added installer generator, schema template, and base configuration defaults.

Status notes:

- This release is still WIP and not production-ready.
- Breaking changes are expected before `1.0`.
