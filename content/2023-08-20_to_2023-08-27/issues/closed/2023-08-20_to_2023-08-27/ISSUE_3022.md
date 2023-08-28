## SUMMARY
- **Issue #3022:** [fix(devimint): properly shutdown lightningd](https://github.com/fedimint/fedimint/pull/3022)

### GPT SUMMARY:
The text explains that if the cln extension is not explicitly shutdown, it may continue running and cause errors in the next execution. The discussion between m1sterc001guy and douglaz suggests that killing the cln extension does not stop it immediately, but takes a few seconds to exit. A command is provided to test this behavior. Additionally, it is mentioned that lightningd does not try to kill the extension even on SIGTERM. douglaz suggests that the drop should be in an inner object protected by Arc to avoid termination issues.

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

