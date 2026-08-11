# Diagram Policy

Use diagrams only when they materially clarify meaningful relationships. Default to
embedded Mermaid blocks in architecture Markdown, not separate image artifacts. Follow a
repository-native format when discovery finds an established documentation convention.
Use [human-readable-output.md](human-readable-output.md) for diagram labels and paths.

## Required triggers and homes

- A cross-system or domain-boundary change requires a current or proposed context or
  component flowchart in the feature overview architecture draft.
- A multi-step API, event, or job interaction requires a sequence diagram in the owning
  domain draft, usually the readable backend architecture path.
- A non-trivial lifecycle or UI/server state change requires a state diagram in the
  relevant readable frontend or backend draft.
- An infrastructure topology, network, resource, or runtime change requires a deployment
  or topology flowchart in the readable infrastructure architecture draft. Show local
  and hosted differences when material.
- More than one planned PR requires a Mermaid dependency DAG in the readable sequence
  artifact. For one PR, state that no dependency diagram is needed.
- Add an ADR diagram only when the decision is hard to understand without it.

One diagram may satisfy multiple triggers. Record `none` when no trigger is justified.

## YAGNI guardrails

Do not diagram trivial field additions, single-step behavior, unchanged topology, or
content that merely repeats prose. Keep each diagram small and focused. Use names that
match the human-readable requirement and contract names, label assumptions, and never
invent undiscovered components. IDs remain hidden node metadata where practical; labels
must not require users to decode them.

## Mermaid safety

Prefer only `flowchart`, `sequenceDiagram`, and `stateDiagram-v2`. Use simple, stable
syntax and camelCase or PascalCase IDs without spaces. Quote labels containing
punctuation or special characters. Avoid reserved IDs such as `end`, HTML, angle
brackets, explicit colors or styles, and click directives.

Validate syntax and rendering with repository tooling when available. Otherwise record a
manual syntax review against these rules and do not claim rendered validation.

## Lifecycle

Planning selects each required diagram before the requirements human gate and records its
purpose, type, home, and source requirements. Draft diagrams are embedded in versioned
run architecture files. Sequencing makes the PR DAG available before sequence approval.
The owning PR carries approved draft diagrams into assigned durable architecture docs.

Reviewers challenge missing, inaccurate, speculative, duplicated, or stale diagrams
without requesting decorative ones. Realignment refreshes only impacted diagrams and
preserves unaffected diagrams. Rename-only changes use aliases to refresh affected labels
without redesigning the diagram.
