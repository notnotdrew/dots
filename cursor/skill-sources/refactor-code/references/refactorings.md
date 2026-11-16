# Refactoring Catalog

Named, behavior-preserving moves. Use one when it makes a real change cheaper or safer. Names follow Fowler; sketches are Ruby. Duck types, objects, and inheritance are options — pick what localizes the next edit.

After each meaningful step, run the narrowest useful test.

## Composing Methods

### Extract Method

**Motivation**: A fragment that can be named, or a comment that explains *what*.

**Mechanics**:
1. Create a method named for *what* it does
2. Copy the fragment in
3. Pass locals that the fragment reads; return values it produces
4. Replace the fragment with a send
5. Test

```ruby
def print_owing(invoice)
  print_banner
  outstanding = calculate_outstanding
  print_details(invoice, outstanding)
end

def print_details(invoice, outstanding)
  puts "name: #{invoice.customer}"
  puts "amount: #{outstanding}"
end
```

### Inline Method

**Motivation**: The body is as clear as the name, or the method exists only to support a wrong abstraction.

**Mechanics**:
1. Confirm it is not a polymorphic override still needed by other types
2. Replace each sender with the body
3. Test after each replacement
4. Delete the method

### Extract Variable

**Motivation**: An expression that needs a name.

**Mechanics**:
1. Confirm no relevant side effects
2. Assign to a well-named local
3. Use the local in place of the expression
4. Test

Prefer an **explaining method** when a name would make the next edit obvious. Skip the extract when the fragment has one home and no reason to vary.

### Inline Variable

**Motivation**: The name adds nothing.

**Mechanics**: Replace uses with the right-hand side, test, delete the local.

### Rename

**Motivation**: The name does not say what the thing is in the domain.

**Mechanics**: Rename method, class, or local everywhere. In Ruby, update callers, tests, and symbol references (`:charge`, `"charge"` in `delegate` / `alias_method`). Test.

### Replace Temp with Query

**Motivation**: A local holds a derived value that others might need, or that clutters a method you want to extract.

**Mechanics**:
1. Extract the right-hand side to a method
2. Replace the temp with a send
3. Test
4. Make it a method on the object that owns the data when envy appears

### Decompose Conditional

**Motivation**: The condition or its branches need names.

```ruby
if summer?(date)
  summer_charge(quantity)
else
  winter_charge(quantity)
end
```

**Mechanics**: Extract Method on the predicate, then-branch, and else-branch.

### Replace Nested Conditional with Guard Clauses

**Motivation**: Edge cases wrap the happy path in arrows of `else`.

```ruby
def pay_amount
  return dead_amount if dead?
  return separated_amount if separated?
  return retired_amount if retired?

  normal_pay_amount
end
```

## Moving Features

### Move Method

**Motivation**: The method uses more of another object's features than its own (feature envy; asking, not telling).

**Mechanics**:
1. List what the method needs from its current home
2. Copy it to the object that owns the data
3. Adjust the receiver and arguments
4. Turn the original into a delegating method, test, then inline the original if nothing else needed it

### Extract Class

**Motivation**: One class has two reasons to change, or a clump of fields and methods that belong together.

**Mechanics**:
1. Create a class named for the role
2. Move fields, then methods, testing after each move
3. Hold the new object as a collaborator (inject it if the owner should not construct it)
4. Update senders

Do not name it `Helper`, `Manager`, or `Service` unless that is honestly the role. If you cannot say why the next change belongs here, you are not ready to extract.

### Inline Class

**Motivation**: The class does not earn its keep, or it is the wrong abstraction.

**Mechanics**: Move remaining behavior back to the caller, test, delete the class.

### Hide Delegate

**Motivation**: Callers walk `a.b.c` (message chain / Demeter).

**Mechanics**: Add a method on `a` that tells `b` to do the useful thing, or that returns the value callers actually need. Replace the chain. Test.

### Remove Middle Man

**Motivation**: The owner only forwards, and the extra hop is noise.

**Mechanics**: Let callers send to the delegate. Keep the middle object if it is a stable boundary (gateway, application edge).

## Organizing Data

### Replace Primitive or Hash with Object

**Motivation**: A string, number, or hash carries domain rules.

```ruby
# Before
def ship(address_hash)
  raise unless address_hash.fetch(:zip).match?(/\A\d{5}\z/)
  carrier.deliver(address_hash.fetch(:line1), address_hash.fetch(:zip))
end

# After
def ship(address)
  carrier.deliver(address.line1, address.zip)
end
```

**Mechanics**: Introduce a small object (or `Data.define` / `Struct` when it is a value). Move validation and queries onto it. Replace hashes at the boundary.

### Introduce Parameter Object

**Motivation**: Arguments that always travel together.

```ruby
def amount_invoiced(range)
  # range starts and ends
end
```

**Mechanics**: Create the object, add it as a parameter, migrate callers, remove the old arguments. Test after each caller if the method is widely sent.

### Encapsulate Field

**Motivation**: Outsiders read and write instance variables or public `attr_accessor`s and then make decisions.

**Mechanics**:
1. `attr_reader` (or a query method) instead of public writers
2. Replace outside uses of the field with messages
3. Move the decisions those callers were making onto this object
4. Test

### Preserve Whole Object

**Motivation**: A caller unpacks an object and passes three of its fields.

**Mechanics**: Pass the object. Let the callee send queries. Test.

### Remove Flag Argument

**Motivation**: A boolean or `kind:` that picks an algorithm.

**Mechanics**: Split into two methods, or replace with a duck type, when the flag is making each new behavior more expensive. A flag that is used once and stable can stay.

## Making Variation Cheap

### Replace Conditional with Polymorphism

**Motivation**: The same type/kind conditional appears in more than one place.

Prefer **duck types** when the same type-conditional lives in more than one place. A single `case` at a construction boundary is often cheaper than a hierarchy. Inheritance is fine when the subtype really is a kind of the parent and that localizes change.

```ruby
# Before
def shipping_cost(order)
  case order.shipping_type
  when "standard" then 5 + order.weight
  when "express"  then 15
  end
end

# After: inject a policy that answers the same message
def shipping_cost(order)
  order.shipping_policy.cost(order)
end

class StandardShipping
  def cost(order) = 5 + order.weight
end

class ExpressShipping
  def cost(_order) = 15
end
```

**Mechanics**:
1. Isolate the conditional with Extract Method
2. Create objects that each implement the role
3. Inject or look up the policy once at the boundary
4. Move one branch at a time, test, delete the `case`

### Extract Duck Type / Inject Collaborator

**Motivation**: Construction or class names leak into the algorithm (`PaymentGateway.new`, `case obj` when `A`, `B`).

**Mechanics**:
1. Name the role (`Auditor`, `Calendar`, `Fulfillment`)
2. Pass it into `initialize` or the method
3. In tests, pass a fake that answers the same messages
4. Keep ActiveRecord / HTTP at the edge

### Introduce Special Case (Null Object)

**Motivation**: `if thing.nil?` is scattered.

**Mechanics**: Introduce an object that answers the same messages with the empty/default behavior. Use it at the boundary. Do not invent one for a single `nil` check.

### Replace Subclass with Delegate

**Motivation**: Inheritance was used for reuse, or a subclass refuses the bequest.

**Mechanics**: Give the former parent a collaborator that holds the varying part. Forward the messages. Delete the hierarchy if nothing is left of is-a.

### Extract Module

**Motivation**: Two classes share a role and a module localizes that role without a parent class.

**Mechanics**: Extract only a coherent role, not a junk drawer. If the module is a pile of helpers, prefer a composed object. Concerns that mix persistence with policy should be split or inlined.

### Collapse Hierarchy

**Motivation**: Parent and child are not different enough, or there is only one subclass.

**Mechanics**: Merge into one class, test, delete the extra type.

## Other Reliable Moves

### Split Phase

**Motivation**: One method both gathers data and applies a later policy (parse then price, load then notify).

**Mechanics**: Extract the second phase. Pass an intermediate object or value. Extract the first phase. Test.

### Replace Loop with Enumerable

**Motivation**: A hand-built loop is a `select`/`map`/`sum`/`each_with_object`.

```ruby
names = people.select { |person| person.role == "programmer" }.map(&:name)
```

**Mechanics**: Convert one operation at a time. Test.

### Separate Query from Modifier

**Motivation**: A method both answers a question and changes state.

**Mechanics**: Split into a query and a command. Callers that needed a value during mutation should send two messages. Test both paths.

### Remove Dead Code

**Motivation**: Unreachable or unsent code.

**Mechanics**: Confirm no senders (including metaprogramming: `send`, `delegate`, Rails callbacks, routes). Delete. Do not comment it out. Test.
