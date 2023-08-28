+++
+++
## SUMMARY
- **Issue #3038:** [chore: use faster `typos` versions](https://github.com/fedimint/fedimint/pull/3038)

### GPT SUMMARY:
The text describes how the combination of two elements, #3037 and #3038, has made the commit check process faster. The execution time before the implementation was 4.86 seconds, but after the implementation, it decreased to 1.33 seconds. This improvement is particularly noticeable when the cache is not warmed up.

## DETAILS
### Description:
In combination with #3037 it makes commit check even faster, especially on cold cache.

Before (`master` branch):

```
Executed in    4.86 secs    fish           external
   usr time   25.39 secs    0.00 micros   25.39 secs
   sys time   10.23 secs  466.00 micros   10.23 secs
```

After (#3037 + #3038):

```
Executed in    1.33 secs    fish           external
   usr time    8.23 secs   20.29 millis    8.21 secs
   sys time    1.54 secs    4.15 millis    1.54 secs
```

### Comments:
No comments for this issue.

