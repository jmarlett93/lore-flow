# Diagram policy fixture

## Input

Add order submission across web, order API, and a hosted queue. Local development uses
an in-process queue adapter. The backend validates, stores, and publishes each order.
Split delivery into backend, frontend, and infrastructure PRs. Also add an optional
`customerNote` field without changing its behavior or relationships.

## Expected architecture diagrams

Cross-domain flow in `architecture/order-submission-overview.md`, sourced by
`CONTRACT-submit-order` and `BEHAVIOR-order-confirmation`:

```mermaid
flowchart LR
  webApp["Web app"] --> orderApi["Order API"]
  orderApi --> orderStore["Order store"]
  orderApi --> orderEvents["Order events"]
```

Backend interaction in `architecture/order-submission-backend.md`, sourced by
`CONTRACT-submit-order`:

```mermaid
sequenceDiagram
  participant webApp as Web app
  participant orderApi as Order API
  participant orderStore as Order store
  participant orderEvents as Order events
  webApp->>orderApi: Submit order
  orderApi->>orderStore: Save validated order
  orderApi->>orderEvents: Publish order submitted
  orderApi-->>webApp: Return confirmation
```

Topology in `architecture/order-submission-infrastructure.md`, sourced by
`BEHAVIOR-order-event-runtime`:

```mermaid
flowchart TB
  localApp["Local backend"] --> localQueue["In-process queue adapter"]
  hostedApp["Hosted backend"] --> hostedQueue["Managed queue"]
  hostedQueue --> hostedWorker["Hosted worker"]
```

## Expected PR dependency DAG

Embed in the readable order-submission sequence artifact before sequence approval:

```mermaid
flowchart LR
  infrastructureQueue["PR-01: Queue infrastructure"] --> backendOrder["PR-02: Order backend"]
  backendOrder --> frontendOrder["PR-03: Order frontend"]
```

## Explicit no-diagram case

`MODEL-customer-note` adds one optional field with no new lifecycle, interaction,
boundary, or topology. It requires no diagram because a diagram would duplicate prose.
No ADR diagram is needed because no hard-to-explain decision exists.
