# Failed Ponytail review

## Input

The authentication unit is implemented and tests pass, but the required
Ponytail review reports that refresh tokens are logged. A session UI depends on
the authentication unit.

## Expected state artifact

```json
{
  "units": {
    "authentication": {
      "status": "review_failed",
      "integrationAllowed": false,
      "requiredReviews": {
        "ponytail": {
          "status": "failed",
          "finding": "refresh tokens are logged"
        }
      },
      "nextAction": "fix_and_rerun_ponytail"
    },
    "session-ui": {
      "status": "blocked",
      "dependsOn": ["authentication"],
      "blockedBy": ["authentication:ponytail"]
    }
  },
  "runStatus": "blocked"
}
```
