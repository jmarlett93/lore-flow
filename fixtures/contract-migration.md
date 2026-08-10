# Contract migration

## Input

Rename the customer field `displayName` to `name` across the API and web app
without downtime. During migration the API must accept and return both fields.
Remove `displayName` only after all consumers use `name`.

## Expected plan artifact

```json
{
  "units": [
    {
      "id": "expand-customer-contract",
      "phase": "expand",
      "dependsOn": []
    },
    {
      "id": "migrate-customer-consumers",
      "phase": "migrate",
      "dependsOn": ["expand-customer-contract"]
    },
    {
      "id": "contract-customer-schema",
      "phase": "contract",
      "dependsOn": ["migrate-customer-consumers"]
    }
  ],
  "sequence": [
    "expand-customer-contract",
    "migrate-customer-consumers",
    "contract-customer-schema"
  ]
}
```
