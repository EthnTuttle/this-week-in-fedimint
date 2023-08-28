+++
+++
## SUMMARY
- **Issue #3020:** [chore(ci): increase linux build timeout](https://github.com/fedimint/fedimint/pull/3020)

### GPT SUMMARY:
The text states that there have been many tests that are timing out while fetching from their nix caches. The author suggests that this could be due to temporary network congestion, but believes that it should not cause the tests to fail. Another person expresses doubt and mentions a conversation with someone named dpc. The author then questions whether the issue resolved itself after a long period of time.

## DETAILS
### Description:
We are [seeing a lot of tests time out](https://github.com/fedimint/fedimint/actions/runs/5953944182/job/16149367352?pr=3008) while fetching from our nix caches, there might be temporary network congestion, but that shouldn't make our tests fail.

### Comments:
- **elsirion:** I doubt it will help after chatting with @dpc about it :(
- **elsirion:** Maybe I was wrong and whatever was stuck unstuck itself after an ungodly amount of time?!

