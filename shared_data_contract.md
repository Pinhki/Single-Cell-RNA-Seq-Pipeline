# Shared Data Contract (Moved)

Canonical location:
- `docs/agents/contracts/SHARED_DATA_CONTRACT.md`

This stub remains for backward compatibility. Update the canonical file above.

## Troubleshooting Confidence Policy

When troubleshooting issues or increasing performance, evaluate confidence first by percentage.
If confidence is not above 95%, ask the user first before applying fixes.
If confidence is below 50%, ignore the current path and rethink before proceeding.
Check whether related functions are affected by the change (for example global behavior, reactive() flow, and cross-page side effects), and whether the fix is a strong guard rather than a temporary patch; if affecting others is inevitable, ask for permission first.

