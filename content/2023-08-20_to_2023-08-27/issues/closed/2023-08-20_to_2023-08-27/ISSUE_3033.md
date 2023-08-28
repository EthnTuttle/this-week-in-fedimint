## SUMMARY
- **Issue #3033:** [chore: pin ldk-node to git hash](https://github.com/fedimint/fedimint/pull/3033)

### GPT SUMMARY:
The text explains that the only factor determining the version of `ldk-node` is the `Cargo.lock` file. However, if someone uses `fedimint-testing` as a library, the `Cargo.lock` file will not have any impact, and they will obtain `ldk-node` directly from the master branch, which could be unstable.

## DETAILS
### Description:
The only thing pinning `ldk-node` to a specific version is our `Cargo.lock`. But if anyone uses `fedimint-testing` as a library, our `Cargo.lock` has no effect and they'll just pull `ldk-node` from master, which will be prone to breaking.

### Comments:
No comments for this issue.

