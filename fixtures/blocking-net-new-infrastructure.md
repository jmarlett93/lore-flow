# Blocking net-new infrastructure

## Input

Add image uploads backed by a new object-storage bucket. The API cannot start or
run its integration tests until the bucket, credentials, and local test
substitute exist. Build the upload API and profile-photo UI afterward.

## Expected plan artifact

```json
{
  "units": [
    {
      "id": "object-storage",
      "kind": "infrastructure",
      "blocking": true,
      "dependsOn": []
    },
    {
      "id": "upload-api",
      "kind": "backend",
      "dependsOn": ["object-storage"]
    },
    {
      "id": "profile-photo-ui",
      "kind": "frontend",
      "dependsOn": ["upload-api"]
    }
  ],
  "sequence": ["object-storage", "upload-api", "profile-photo-ui"]
}
```
