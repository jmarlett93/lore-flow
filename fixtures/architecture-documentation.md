# Architecture documentation ownership

## Input

Add a versioned bulk-export API backed by a new object-storage bucket. Document the API
contract, deployment/storage topology, and the decision to use asynchronous export jobs.
The repository has no architecture or ADR convention.

## Expected plan artifact

```json
{
  "drafts": [
    "architecture/overview.md",
    "architecture/backend.md",
    "architecture/infrastructure.md",
    "architecture/adr/async-export-jobs.md"
  ],
  "units": [
    {
      "id": "PR-01",
      "area": "infrastructure",
      "durableDocs": ["docs/architecture/export-storage.md"]
    },
    {
      "id": "PR-02",
      "area": "backend",
      "dependsOn": ["PR-01"],
      "durableDocs": [
        "docs/architecture/bulk-export-api.md",
        "docs/adr/async-export-jobs.md"
      ]
    }
  ]
}
```

The infrastructure document is owned by the infrastructure PR. The API contract and ADR
are owned once by the contract-producing backend PR; no mixed-domain documentation PR is
created.
