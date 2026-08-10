# Late infrastructure

## Input

Add request correlation IDs in the existing API and display them on the current
support page. After the application behavior is complete, update the existing
log dashboard to include the ID. The dashboard change does not block build,
test, deployment, or runtime.

## Expected plan artifact

```json
{
  "units": [
    {
      "id": "correlation-api",
      "kind": "backend",
      "dependsOn": []
    },
    {
      "id": "correlation-ui",
      "kind": "frontend",
      "dependsOn": ["correlation-api"]
    },
    {
      "id": "correlation-dashboard",
      "kind": "infrastructure",
      "blocking": false,
      "dependsOn": ["correlation-api", "correlation-ui"]
    }
  ],
  "sequence": [
    "correlation-api",
    "correlation-ui",
    "correlation-dashboard"
  ]
}
```
