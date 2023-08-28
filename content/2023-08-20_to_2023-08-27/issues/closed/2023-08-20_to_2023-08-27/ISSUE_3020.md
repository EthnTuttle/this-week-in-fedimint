## SUMMARY
- **Issue #3020:** [chore(ci): increase linux build timeout](https://github.com/fedimint/fedimint/pull/3020)

### GPT SUMMARY:
The text mentions that there have been several instances where tests are timing out while fetching from nix caches. It is suggested that this might be due to temporary network congestion, but it should not cause the tests to fail. One person expresses doubt that discussing the issue with someone else will help resolve it. Another person suggests that the problem might have resolved itself after a long period of time.

## DETAILS
### Description:
We are [seeing a lot of tests time out](https://github.com/fedimint/fedimint/actions/runs/5953944182/job/16149367352?pr=3008) while fetching from our nix caches, there might be temporary network congestion, but that shouldn't make our tests fail.

### Comments:
- **elsirion:** I doubt it will help after chatting with @dpc about it :(
- **elsirion:** Maybe I was wrong and whatever was stuck unstuck itself after an ungodly amount of time?!

