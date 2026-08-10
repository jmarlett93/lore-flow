# Frontend-first no-op exception

## Input

Add the disabled export button and its accessible help text now. The export API
will be delivered in a later unit.

Required sequencing note: `button calls unimplemented endpoint - no-op for now`

## Expected plan artifact

```json
{
  "units": [
    {
      "id": "export-button",
      "kind": "frontend",
      "dependsOn": [],
      "exception": {
        "type": "frontend-first-no-op",
        "note": "button calls unimplemented endpoint - no-op for now"
      }
    },
    {
      "id": "export-api",
      "kind": "backend",
      "dependsOn": []
    },
    {
      "id": "connect-export",
      "kind": "frontend",
      "dependsOn": ["export-button", "export-api"]
    }
  ]
}
```
