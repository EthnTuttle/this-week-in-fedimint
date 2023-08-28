+++
+++
## SUMMARY
- **Issue #3022:** [fix(devimint): properly shutdown lightningd](https://github.com/fedimint/fedimint/pull/3022)

### GPT SUMMARY:
The text discusses the issue of the cln extension continuing to run even after the main program is shut down, which can lead to errors in the next execution. One person suggests that killing the cln extension should also stop the extension, but another person disagrees and provides evidence that the cln extension takes several seconds to exit after being killed. The text also mentions a command to test the behavior of the cln extension and suggests a possible solution to the issue.

## DETAILS
### Description:
The cln extension may continue running for a while if we don't shutdown it explicitly. This may cause errors on the next execution.

Also moved some utility cli commands from load-test-tool to devimint

### Comments:
- **m1sterc001guy:** I thought killing CLN would cause the extension to stop too? We had issues with this in the past but I thought we had fixed those problems
- **douglaz:** > I thought killing CLN would cause the extension to stop too? We had issues with this in the past but I thought we had fixed those problems

It doesn't seems to receive a kill at the same time. It keeps running for many seconds then it seems to realize lightningd is dead, then it exits.

- **douglaz:** A command to test is inside `just mprocs`:
```bash
killall lightningd;for i in {0..1000}; do echo $i;killall -0 gateway-cln-extension || break;sleep 0.1;done
```

On my machine it takes >12s for gateway-cln-extension to disappear

You can also see that if you send a SIGKILL the time is the same:

```bash
killall -9 lightningd;for i in {0..1000}; do echo $i;killall -0 gateway-cln-extension || break;sleep 0.1;done
```
So lightningd doesn't try to kill the extension even on SIGTERM.
- **douglaz:** Drop should be in a inner object protected by `Arc`, otherwise we may keep try to terminate when a cloned object goes out of context.

