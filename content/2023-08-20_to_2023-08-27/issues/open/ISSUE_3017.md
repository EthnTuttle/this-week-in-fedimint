+++
+++
## SUMMARY
- **Issue #3017:** [`just mprocs` errors on start](https://github.com/fedimint/fedimint/issues/3017)

### GPT SUMMARY:
null

## DETAILS
### Description:
```
2023-08-22T22:47:49.145684Z  WARN consensus: ERROR FederationError { general: Some(Received errors from 2 peers

Stack backtrace:
   0: fedimint_core::query::ErrorStrategy::process
             at ./fedimint-core/src/query.rs:106:31
   1: <fedimint_core::query::ThresholdConsensus<R> as fedimint_core::query::QueryStrategy<R>>::process
             at ./fedimint-core/src/query.rs:169:27
   2: fedimint_core::api::FederationApiExt::request_with_strategy::{{closure}}
             at ./fedimint-core/src/api.rs:236:41
   3: <core::pin::Pin<P> as core::future::future::Future>::poll
             at /rustc/eb26296b556cef10fb713a38f3d16b9886080f26/library/core/src/future/future.rs:125:9
   4: fedimint_core::api::FederationApiExt::request_current_consensus::{{closure}}
             at ./fedimint-core/src/api.rs:300:10
   5: <core::pin::Pin<P> as core::future::future::Future>::poll
             at /rustc/eb26296b556cef10fb713a38f3d16b9886080f26/library/core/src/future/future.rs:125:9
   6: <T as fedimint_core::api::GlobalFederationApi>::consensus_config_hash::{{closure}}
             at ./fedimint-core/src/api.rs:560:14
   7: <core::pin::Pin<P> as core::future::future::Future>::poll
             at /rustc/eb26296b556cef10fb713a38f3d16b9886080f26/library/core/src/future/future.rs:125:9
   8: fedimint_server::consensus::server::ConsensusServer::run_consensus::{{closure}}
             at ./fedimint-server/src/consensus/server.rs:263:52
   9: fedimint_server::FedimintServer::run::{{closure}}
             at ./fedimint-server/src/lib.rs:100:56
  10: <futures_util::future::maybe_done::MaybeDone<Fut> as core::future::future::Future>::poll
             at /home/dpc/.cargo/registry/src/index.crates.io-6f17d22bba15001f/futures-util-0.3.28/src/future/maybe_done.rs:95:38
  11: fedimintd::fedimintd::run::{{closure}}::{{closure}}
             at /home/dpc/.cargo/registry/src/index.crates.io-6f17d22bba15001f/futures-util-0.3.28/src/async_await/join_mod.rs:95:13
  12: <futures_util::future::poll_fn::PollFn

...

  56: main
  57: __libc_start_call_main
  58: __libc_start_main@@GLIBC_2.34
  59: _start), peers: {PeerId(1): Rpc(Call(ErrorObject { code: MethodNotFound, message: "Method not found", data: None })), PeerId(2): Rpc(Call(ErrorObject { code: MethodNotFound, message: "Method not found", data: None }))} }
```


Seems like after dkg, other peers were not ready yet while other peers started to aggressively attempt to run consensus.

### Comments:
No comments for this issue.

