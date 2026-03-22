# AGENTS.md

Instructions for AI coding agents working in this gem.

## Scope

- This repository is the `solid_agents` Rails engine gem.
- Keep names and namespaces consistent with `SolidAgents`.
- Follow Rails engine conventions used by the solid_* gems.
- `solid_agents` owns automation execution workflows:
  - consume incident/trace APIs (for example from `solid_events`)
  - execute fix/test/PR/QA/review workflows through runtimes
  - track run state, artifacts, and execution history
- Do not add source-of-truth observability storage or incident detection/lifecycle ownership here; that belongs in `solid_events`.

## Development rules

- Prefer minimal, focused changes over broad refactors.
- Keep public API changes reflected in `README.md`.
- Add or update Minitest coverage for behavior changes.
- Run tests with Ruby `4.0.1`.

## Commit rules

- Never use `git add .`; stage files explicitly by path.
- Use one logical change per commit.
- Commit messages must be one direct sentence.
- Do not use commit prefixes like `feat:`, `fix:`, `chore:`, etc.
