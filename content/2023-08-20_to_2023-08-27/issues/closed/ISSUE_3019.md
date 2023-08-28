+++
+++
## SUMMARY
- **Issue #3019:** [feat(shell): wait for background processes to exit](https://github.com/fedimint/fedimint/pull/3019)

### GPT SUMMARY:
The text discusses the inconvenience of scripts that exit but leave processes running, which can cause failures if other scripts start immediately and use the same resources. A person named douglaz suggests having a better idea.

## DETAILS
### Description:
It's inconvenient when a script exits but still leaves stuff running (even if these processes have just received a signal and will hopefully die soon). This can cause failures if some other script starts right away and uses the same resources.

### Comments:
- **douglaz:** I have a better idea

