## SUMMARY
- **Issue #3016:** [It's possible to trigger db commit conficts from the API](https://github.com/fedimint/fedimint/issues/3016)

### GPT SUMMARY:
The text describes a situation where the program "just mprocs" is taking a while to start. It is noted that one of the peers is dumping lots of stack traces, causing a noisy environment. The stack trace provided in the text has more than 40 levels. The suggestion is made to address this condition if it is expected to be triggered from the outside, possibly related to the gateways registering simultaneously.

## DETAILS
### Description:
and it's super noisy.

When I was running `just mprocs` I've noticed it was taking a while to start, and then I noticed that one of the peers is dumping lots of stack traces:

```
2023-08-22T22:48:11.897239Z  WARN connection{remote_addr=127.0.0.1:44778 conn_id=5}: net::api: API server error when writing to database: Resource busy: 

Stack backtrace:
   0: <core::result::Result<T,F> as core::ops::try_trait::FromResidual<core::result::Result<core::convert::Infallible,E>>>::from_residual
             at /rustc/eb26296b556cef10fb713a38f3d16b9886080f26/library/core/src/result.rs:1961:27
   1: <fedimint_rocksdb::RocksDbTransaction as fedimint_core::db::IDatabaseTransaction>::commit_tx::{{closure}}::{{closure}}
             at ./fedimint-rocksdb/src/lib.rs:223:13
   2: tokio::runtime::context::exit_runtime
             at /home/dpc/.cargo/registry/src/index.crates.io-6f17d22bba15001f/tokio-1.28.1/src/runtime/context.rs:418:9
   3: tokio::runtime::scheduler::multi_thread::worker::block_in_place
             at /home/dpc/.cargo/registry/src/index.crates.io-6f17d22bba15001f/tokio-1.28.1/src/runtime/scheduler/multi_thread/worker.rs:356:9
   4: tokio::task::blocking::block_in_place
             at /home/dpc/.cargo/registry/src/index.crates.io-6f17d22bba15001f/tokio-1.28.1/src/task/blocking.rs:78:9
   5: fedimint_core::task::imp::block_in_place
             at ./fedimint-core/src/task.rs:414:9
   6: <fedimint_rocksdb::RocksDbTransaction as fedimint_core::db::IDatabaseTransaction>::commit_tx::{{closure}}
             at ./fedimint-rocksdb/src/lib.rs:222:9
   7: <core::pin::Pin<P> as core::future::future::Future>::poll
```


This stack trace had > 40 levels, so looked very noisy. If we expect this condition to be triggered from the outside, maybe we should do something about it?

### Comments:
- **elsirion:** Might this be the gateways registering at the same time?

