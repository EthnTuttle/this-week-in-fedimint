+++
+++
## SUMMARY
- **Issue #3021:** [feat(shell): wait for background processes to exit](https://github.com/fedimint/fedimint/pull/3021)

### GPT SUMMARY:
The text highlights the inconvenience of scripts that exit but leave processes running, even if they are expected to terminate soon. This situation can lead to failures if another script begins immediately and relies on the same resources.

## DETAILS
### Description:
It's inconvenient when a script exits but still leaves stuff running (even if these processes have just received a signal and will hopefully die soon). This can cause failures if some other script starts right away and uses the same resources.

### Comments:
No comments for this issue.

