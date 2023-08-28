## SUMMARY
- **Issue #3014:** [chore: clean up naming of tests a bit](https://github.com/fedimint/fedimint/pull/3014)

### GPT SUMMARY:
null

## DETAILS
### Description:
* Get rid of that "cli" everywhere. It means nothing(?).
* Singular is better than plural.

### Comments:
- **justinmoon:** These tests were originally called "cli tests" because they were written in bash and exercised `fedimint-cli`. Agree it's good to get rid of.
- **elsirion:** The `wasm-tests.sh` -> `wasm-test.sh` broke CI.

