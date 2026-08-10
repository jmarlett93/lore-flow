# Backend-first feature

## Input

Add a saved-search feature. The API must persist a named query and expose
`POST /saved-searches`; the web app then adds a form that calls the endpoint.
Include backend and frontend tests.

## Expected plan artifact

```json
{
  "preset": "normal",
  "units": [
    {
      "id": "saved-search-api",
      "kind": "backend",
      "dependsOn": []
    },
    {
      "id": "saved-search-ui",
      "kind": "frontend",
      "dependsOn": ["saved-search-api"]
    }
  ],
  "sequence": ["saved-search-api", "saved-search-ui"]
}
```
