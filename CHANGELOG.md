# Changelog

All notable changes to `solid_agents` will be documented in this file.

## [0.1.0] - 2026-03-22

Initial public release (WIP).

- Introduced `solid_agents` Rails engine for database-backed agent run orchestration.
- Added run lifecycle models and persistence for runs, events, artifacts, agents, and config.
- Added dispatch and execution flow with runtime adapters for TinyClaw and OpenClaw.
- Added built-in UI/controllers for managing agents and inspecting runs.
- Added installer generator, schema template, and base configuration defaults.

Status notes:

- This release is still WIP and not production-ready.
- Breaking changes are expected before `1.0`.
