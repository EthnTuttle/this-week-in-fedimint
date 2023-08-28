+++
+++
## SUMMARY
- **Issue #3010:** [Cargo audit findings](https://github.com/fedimint/fedimint/issues/3010)

### GPT SUMMARY:
The text states that the `cargo audit` tool has identified several dependencies that are causing issues. These dependencies include atty v0.2.14, webpki v0.22.0, webpki v0.21.4, and rustls v0.100.0. However, the author mentions that these issues are not critical and can be fixed over time. They also suggest coordinating with the ongoing project to update the `rust-bitcoin` dependency, which may resolve the problems with newer versions of `electrum-client`.

## DETAILS
### Description:
[`cargo audit` is complaining about the following dependencies](https://github.com/fedimint/fedimint/actions/runs/5940802339/job/16110189706?pr=3009):

* [atty v0.2.14](https://rustsec.org/advisories/RUSTSEC-2021-0145)
* [webpki v0.22.0](https://rustsec.org/advisories/RUSTSEC-2023-0052)
* [webpki v0.21.4](https://rustsec.org/advisories/RUSTSEC-2023-0052)
* [rustls v0.100.0](https://rustsec.org/advisories/RUSTSEC-2023-0053)

### Comments:
- **elsirion:** None of these seem super critical to fix: either DoS (we have a lot of DoS potential vectors in our own code) and the `atty` exploit only works on windows. Let's still try to get rid of them, but we have the time to coordinate with e.g. the ongoing project to update the `rust-bitcoin` dependency (#2667) which will likely unblock newer `electrum-client` versions.

