+++
+++
## SUMMARY
- **Issue #3025:** [Future proof arguments to `ClientModuleInit::init`](https://github.com/fedimint/fedimint/issues/3025)

### GPT SUMMARY:
The text suggests creating a struct called "ModuleInitArgs" in Rust, which would contain private fields. The struct would have methods such as "db" and "api_version" to access specific fields. By passing this struct instead of individual arguments, it would be easier to add or remove fields without breaking the API. The idea is to identify the essential arguments for all modules and use functional options for optional ones. The suggestion is influenced by the concept of functional options for friendly APIs.

## DETAILS
### Description:
I noticed we keep tweaking these, adding, removing refactoring arguments there, forcing changes in downstream implementations.

Maybe we should pass one:

```rust 
struct ModuleInitArgs {
  // all fields private
}
```

than then has:

```rust
impl ModuleInitArgs {
  pub db(&self) -> &Database {
    // ...
  }

  pub fn api_version(&self) -> ApiVersion  {
    // ...
  }

  // other methods
}
```

then we can add new fields, deprecate old ones etc. without breaking the Api.


We probably should do it in some other module API traits methods as well, but need to be careful not to go overboard with it. Things that have multiple arguments that historically changed.

### Comments:
- **shaurya947:** I definitely pondered on this while working on #3024 

It seemed to me that not all parts of the args are used by every module (for example the federation ID that I just added). If we could identify the must-have args for all the modules and bundle them into a struct, and use functional options for the optional ones on a per-module basis, what that be a good idea?

I read this some time ago and it influenced me quite a bit: https://dave.cheney.net/2014/10/17/functional-options-for-friendly-apis

