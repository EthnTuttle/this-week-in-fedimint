## SUMMARY
- **Issue #3025:** [Future proof arguments to `ClientModuleInit::init`](https://github.com/fedimint/fedimint/issues/3025)

### GPT SUMMARY:
The author suggests creating a struct called ModuleInitArgs to handle arguments in a more organized way. By doing this, new fields can be added and old ones deprecated without breaking the API. The author also mentions the possibility of applying this approach to other module API traits methods, although they caution against going overboard with it. They reference a previous discussion on the topic and suggest using functional options for optional arguments on a per-module basis. The author cites an article on functional options for friendly APIs as an influence on their thinking.

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

