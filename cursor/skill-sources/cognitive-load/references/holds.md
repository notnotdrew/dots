# Holds

Worked extras from [Cognitive load is what matters](https://github.com/zakirullin/cognitive-load). Use a row when counting that kind of chunk. Do not treat this as a second checklist.

A chunk is one fact in working memory. Over ~4 is overload. Empty the slot in the code; do not add a shallow hop that the reader must also hold.

## Compound boolean

Holds each clause, and that the previous clauses were true.

```
if val > someConstant
    && (condition2 || condition3)
    && (condition4 && !condition5) {
```

Empty: name `isValid`, `isAllowed`, `isSecure`. The `if` only ands the names.

## Nested preconditions

Holds each outer guard while reading the inner work.

Empty: early returns. The work sits on the happy path. The reader drops the failed cases.

## Inheritance climb

Holds each parent to find the behavior (`AdminController` extends `UserController` extends `GuestController` extends `BaseController`, and a child may still break).

Empty: composition. Behavior lives where the reader is looking.

## Shallow modules

A shallow module has a complex interface around a small job. `MetricsProviderFactoryFactory` is the name of the miss. The reader holds every module and every collaboration.

A deep module has a simple interface around complex functionality. Unix I/O is five calls over a large implementation. Linear to read.

Empty: fewer, deeper modules. Important work can be large. Do not split it into a sea of fifteen-line methods so the reader has to jump.

A module is responsible to one user or stakeholder, not "one thing." Instantiating an object is not a reason to exist.

## Language features

Holds the feature, and why the author chose it from the set that was available.

Empty: the everyday subset. Orthogonal features are fine. A line that requires recalling the standard is the miss.

## Custom mappings

Holds `401` is expired, `403` is denied, `418` is banned — on the backend, then again on the frontend, then again for QA.

Empty: a self-describing value in the body (`jwt_has_expired`). Prefer strings over numeric statuses. Prefer "login" and "permissions" over "authentication" and "authorization" when those two words themselves cost a slot.

## DRY as a dependency

Holds the shared extraction and every caller that now depends on it. A little copying is better than a little dependency. Imported libraries are your code when they blow up.

Empty: leave the duplication, or write the small function. Do not couple unrelated components to avoid repeating a few lines.

## Framework magic

Holds the framework's hidden path before the business path.

Empty: business logic uses the framework as a library. The core does not live inside it.

## Layers that hop

Holds each port, adapter, and glue file on the way to the work. Abstraction that hides complexity is fine. Indirection that adds a jump is load.

Empty: dependency inversion without the extra horizontal layers. Add a layer when you need an extension point you can point at, not an architecture.

Storage migrations do not get cheaper because of a repository wrapper. The observable behavior is the contract.

## Familiar mess

Familiarity is not a light hold. The author internalized the chunks. A new reader has not. There is no simplifying force except a deliberate emptying.
