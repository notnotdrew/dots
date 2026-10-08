# Code Smells

Signals that **change is getting expensive** — not violations to clear. A smell is worth acting on when it sits on the path you need to walk. Consult [design-heuristics.md](design-heuristics.md) before extracting.

Usual refactorings are starting points, not prescriptions.

## Bloaters

### Long Method
**Detection**: Mixes jobs or levels of abstraction so the next edit has no obvious paragraph to land in. Line count is irrelevant if the method is one change in one place.
**Evidence**: Comments as section headers; blank-line-separated "paragraphs"; validate then persist then notify.
**Refactorings**: Extract Method, Replace Temp with Query, Introduce Parameter Object, Decompose Conditional

### Large Class
**Detection**: Unrelated responsibilities; instance variables that cluster into groups.
**Evidence**: Prefixed method names (`order_total`, `order_validate`); variables used by only some methods.
**Refactorings**: Extract Class, Extract duck type and inject it, Replace Type Code with Polymorphism

### Long Parameter List
**Detection**: Many parameters, or parameters that always travel together, or a parameter that is only used to send a message to another parameter.
**Evidence**: Same argument groups in multiple methods.
**Refactorings**: Replace Parameter with Query, Preserve Whole Object, Introduce Parameter Object, Remove Flag Argument

### Data Clumps
**Detection**: The same fields appear together in multiple places.
**Evidence**: Repeated parameter groups; hashes with the same keys threaded through the app.
**Refactorings**: Extract Class, Introduce Parameter Object, Preserve Whole Object, Replace Hash with Object

### Primitive Obsession
**Detection**: Strings, integers, or hashes standing in for domain concepts (money, email, plan name, date range).
**Evidence**: Scattered validation, duplicated formatting, `case status` on a string.
**Refactorings**: Replace Primitive/Hash with Object, Replace Type Code with Duck Type

## Object-Orientation Abusers

### Switch / Case on Type
**Detection**: `case`/`when` or `if` chains on type, class name, or a string code — especially when the same chain appears twice.
**Evidence**: Adding a variant requires editing every case.
**Refactorings**: Replace Conditional with Polymorphism, Extract Duck Type, Replace Type Code with Classes

### Parallel Inheritance Hierarchies
**Detection**: A subclass in one tree forces a subclass in another.
**Evidence**: Matching name prefixes (`OrderProcessor` / `OrderValidator`).
**Refactorings**: Move Method, Move Field, collapse toward composition

### Refused Bequest
**Detection**: Subclass ignores inherited API, or overrides to raise `NotImplementedError`.
**Evidence**: Empty overrides; `super` never called; `is_a?` checks after treating it as the parent.
**Refactorings**: Push Down Method, Replace Subclass with Delegate, collapse the hierarchy

### Alternative Classes with Different Interfaces
**Detection**: Two objects play the same role with different method names.
**Evidence**: Adapters, duplicated algorithms with renamed messages.
**Refactorings**: Rename Method, Extract Duck Type, Move Method

### Wrong Abstraction
**Detection**: Shared code that needs flags, `kind`, or growing `if`s so every new variant edits the hub.
**Evidence**: `Base*` / `*Helper` / `*Service` with mode parameters; adding a variant is still expensive.
**Refactorings**: Inline Class / Inline Method if the hub is costing more than it saves; extract a *role* only when the next variant would then be cheap

## Change Preventers

### Divergent Change
**Detection**: One class changes for multiple unrelated reasons.
**Evidence**: "I edit `Order` for tax *and* for email templates."
**Refactorings**: Extract Class, Split Phase, Move Method

### Shotgun Surgery
**Detection**: One change edits many classes.
**Evidence**: A small feature touches a dozen files.
**Refactorings**: Move Method, Move Field, Combine methods into one class/role, Hide Delegate

### Feature Envy
**Detection**: A method uses more of another object's API than its own.
**Evidence**: Strings of getters on one collaborator; decisions made from someone else's fields.
**Refactorings**: Move Method, Extract Method then Move; tell the other object to do it

## Dispensables

### Comments That Repeat the Code
**Detection**: Comments explain *what*, not *why*.
**Evidence**: `# calculate discount` above the discount calculation.
**Refactorings**: Extract Method, Rename, delete the comment

### Duplicate Code
**Detection**: Same structure in multiple places.
**Evidence**: Copy-paste; similar algorithms with one-line differences.
**Refactorings**: Extract Method, Pull Up when a parent already is the right home, otherwise compose. Two copies that have not diverged can stay.

### Lazy Class
**Detection**: Class or module does not earn its keep.
**Evidence**: One-line wrappers, a module with a single method used once.
**Refactorings**: Inline Class, Collapse Hierarchy

### Speculative Generality
**Detection**: Hooks for features that do not exist.
**Evidence**: Unused arguments, abstract parents with one child, `Flexible*` names.
**Refactorings**: Collapse Hierarchy, Inline Method, Remove Dead Code

### Dead Code
**Detection**: Never executed.
**Evidence**: No senders, unreachable branches, commented-out leftovers.
**Refactorings**: Remove Dead Code

## Couplers

### Message Chains
**Detection**: `a.b.c.d`.
**Evidence**: Views and helpers that walk ActiveRecord associations for domain decisions.
**Refactorings**: Hide Delegate, Extract Method, Move Method

### Middle Man
**Detection**: Most methods only forward.
**Evidence**: One-line `delegate`s and nothing else.
**Refactorings**: Remove Middle Man, Inline Method — unless the middle object is a stable boundary (then keep it)

### Inappropriate Intimacy
**Detection**: Objects reach into each other's guts.
**Evidence**: Sending to private-ish methods; bidirectionally poking instance variables; `send` to bypass visibility.
**Refactorings**: Move Method, Move Field, Hide Delegate, Replace Subclass with Delegate

### Asking, Not Telling
**Detection**: Caller pulls state and makes the decision the callee should own.
**Evidence**: `if user.admin? && user.account.active?` in three places.
**Refactorings**: Move Method onto the object that has the data; Extract Duck Type for the role

### Leaked Knowledge
**Detection**: A class knows another class's construction, descendants, or storage.
**Evidence**: `case payment` when `CreditCard`, `Paypal`; `User.find` inside a PORO that should have been injected a user.
**Refactorings**: Inject the collaborator, Replace Conditional with Polymorphism, Extract Factory if construction is the leak

## How expensive?

Judge against **the change in front of you**, not a global cleanliness score.

**Critical**: You cannot make this week's change without touching many places, guessing, or extending a hub that already fights you.

**High**: The class or method you must edit hides the insertion point, or the same type-conditional will have to gain another branch in several homes.

**Medium**: Clumps, long parameter lists, or chains that will spread if this area keeps growing — but they are not blocking this edit.

**Low**: Speculative wrappers, unused hooks, comments that could be names, duplication that has not diverged. Leave them unless you are already there and the fix is mechanical.
