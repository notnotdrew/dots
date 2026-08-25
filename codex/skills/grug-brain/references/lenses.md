# Grug lenses (from grugbrain.dev)

Use these when a finding needs a sharper call. Do not dump this list into the review.

## Complexity

Apex predator. If grug cannot see the t-rex, that is complexity. Best trap is a **narrow cut-point**: few functions that hide a mess. Extra files with the same mess is not a trap; that is the demon with more rooms.

Magic word is **no**. Second magic word is **ok** plus an 80/20: most of the want, 20 of the code.

## Factoring

Do not factor while the system is still water. Wait until cut-points appear. Wrong abstraction early is how big-brain leave and grug inherit the swamp.

## Testing

- Tests that save future-grug: good.
- Tests before anyone understands the domain: shaman.
- Unit tests glued to internals: break on every refactor, low value.
- Giant end-to-end suites that always red: tribe learns to ignore. Bad.
- Sweet spot: in-between tests at stable cut-points (integration).
- Mock only at coarse system boundaries, rare/never otherwise.
- Bug found? Reproduce with a regression test first. This “first test” grug like.

## Refactor

Small steps. System stays working. Big-bang rewrite and “introduce the one true abstraction” often fail. Stay not too far from shore.

## Chesterton fence

Ugly working code may be holding the road up. If you cannot say why the fence is there, do not smash. Tests often explain the fence.

## Types, generics, closures

Types good when they make the tool show what grug can do (hit dot, list appear). Generics mostly for containers. Closures mostly for “do this to each thing in collection.” Salt: a little good, a lot is callback hell.

## Expression complexity

Fewer lines is not clearer. Named locals for each conjunct make debug possible. Dense `if` soup is how bugs hide.

## DRY and SoC

Repeated simple code with small variation often cheaper than the wrong shared abstraction.

Prefer **locality of behavior**: put the code on the thing that does the thing. CSS/HTML/JS split (and cousins) make grug hunt many files to understand one button.

## APIs

Layer them. Simple case is one call. Complex case can be extra API. Do not make every caller collect streams, supply comparators, open files in the right mood, etc., for the common path. Put the operation on the thing (`list.filter`) not on a nearby philosophy object.

## Concurrency, optimize, network

Fear concurrency. Prefer stateless handlers and independent jobs.

Do not optimize without a real profile. Nested loops are rarely the t-rex; network calls are.

Microservices: taking the hardest problem (factoring) and adding a network. Grug confused why.

## Front end and fads

Two codebases plus JSON-over-HTTP for a form is two demon lairs. New ritual is often old bad idea with new hat. Grain of salt.

## FOLD and impostor

Senior grug must say “this too complex for grug” in public. Fear Of Looking Dumb feeds the demon. Impostor feeling is normal; still club the complexity, not the junior.

## Not the point

Grug is not anti-test, anti-type, anti-tool, or anti-smart. Grug loves tools, debuggers, logs, and tests that earn their keep. Grug is anti-complexity that does not pay.
