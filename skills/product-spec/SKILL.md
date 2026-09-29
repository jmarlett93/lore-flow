---
name: product-spec
description: Interviews a product owner and iterates an approved product requirements document using the target repository's durable product context.
---

# Product Spec

Create or revise a product requirements document without implementing software.
This is the product-discovery mode for Universal Flow. It ends with an
explicitly approved PRD that can be passed to `orchestrate-feature`.

## Inputs

Require:

- target repository path
- product idea, requested change, or existing PRD to revise

Accept an optional PRD slug, desired output path, and human decisions already
made. The target repository must be a Git repository.

## Product context

Use `product/` as the durable product context directory. Before asking
questions, inspect:

- `product/CURRENT_PRODUCT_STATE.md`
- `product/PERSONAS.md`
- `product/GLOSSARY.md`
- existing files under `product/` and `docs/` that are clearly product or PRD
  documents

If the first three files do not exist, create them from the templates in
`templates/product/`. Do not replace an existing file or silently rewrite
unconfirmed product facts. If a context file is missing information, record
the gap and ask about it.

`CURRENT_PRODUCT_STATE.md` is the baseline of what is true now. It must not be
rewritten to describe proposed behavior. A proposed change belongs in the PRD.
Update current state only when the human explicitly confirms that the product
has changed.

## Interview loop

Run a focused interview in rounds. Ask only the highest-value unanswered
questions, grouped so the human can answer efficiently. Use existing product
context and reasonable defaults; label assumptions instead of presenting them
as facts.

Cover, as applicable:

- problem, target users, and user context
- desired outcome and measurable success
- primary journey and important alternate or failure paths
- scope and explicit non-goals
- roles, permissions, and data boundaries
- accessibility, device, localization, and operational needs
- constraints, dependencies, risks, and rollout expectations
- acceptance criteria and definition of done

After each answer round:

1. Update the draft PRD.
2. List resolved assumptions and remaining open questions.
3. Check the draft against the product context for conflicts.
4. Ask the next smallest set of questions that materially affects product
   behavior.

Do not start technical discovery, choose an implementation, or launch builders.
Escalate product choices rather than resolving them as technical details.

## PRD shape

Write the draft using this structure:

```md
# Product Spec: <name>

## Problem
## Users and context
## Desired outcome and success measures
## User stories
## Primary journey
## In scope
## Out of scope
## Functional requirements
## UX and accessibility requirements
## Data, permissions, and operational requirements
## Constraints and dependencies
## Risks and open questions
## Acceptance criteria
## Definition of done
```

Requirements and acceptance criteria must describe observable product behavior.
Use the glossary's canonical terms and identify conflicts with existing
personas or current state.

## Review and approval loop

Before requesting approval, review the draft for:

- a clear problem and user
- necessary and sufficient scope
- explicit non-goals
- coherent journeys and failure behavior
- testable acceptance criteria
- accessibility and permission implications
- unresolved product decisions
- contradictions with current state, personas, or glossary

If material gaps remain, return to the interview. Do not ask for approval of a
PRD containing unresolved choices that would change product behavior.

Present the exact draft path and a short change summary. Pause for explicit
human approval. An approval must name the PRD version or exact file contents;
silence, an edited file, or a conversational “looks good” without identifying
the artifact is not approval.

If the human requests changes, preserve the prior draft, record the feedback
and resulting decisions, revise only the affected sections, and repeat review
and approval. Never overwrite approved history.

## Outputs

Create or update:

- `product/prds/<feature-slug>.md` as the approved PRD
- `.universal-flow/product-specs/<run-id>/` as ignored run evidence, including
  interview decisions, context inventory, draft versions, review findings, and
  approval record

The final report must state one of:

- `approved` — exact PRD path and version approved
- `awaiting-human-review` — exact draft and approval action required
- `clarification-required` — the smallest unanswered product decisions
- `blocked` — missing repository access or required context

After approval, hand the PRD path to `orchestrate-feature`; do not invoke it
automatically unless the human explicitly requests implementation.
