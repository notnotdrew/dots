# Functional Smells

Use this as a short triage sheet, not a full catalog.

## Fast Read

| Smell | Look For | First Move |
| --- | --- | --- |
| Impure function | business logic mixed with IO, logging, DB, ETS, messages | Extract Pure Function |
| Hidden side effect | `calculate_*` or `build_*` functions that write or mutate | Rename or split pure work from effects |
| Boolean blindness | boolean returns or flag params that hide meaning | Return tagged results or split functions |
| Primitive obsession | raw strings, ints, atoms carrying domain meaning | Introduce value struct or tagged data |
| Naked map | ad hoc maps standing in for domain records | Introduce struct |
| Stringly typed state | `"active"` / `"pending"` / magic strings everywhere | Introduce atoms, enums, or tagged data |
| Missing pattern match | `if` or `cond` where data shape is doing the work | Replace with function clauses or pattern match |
| Nested `case` | rightward drift around `{:ok, _}` / `{:error, _}` | Introduce `with` or extract steps |
| Exception as control flow | `raise`/`rescue` for expected outcomes | Return result tuples |
| Pipeline breakage | temp vars that only feed the next transform | Compose pipeline |
| Boundary leakage | effectful code spread through pure core | Push side effects to boundary |

## Severity

- `high`: blocking a current feature, hiding bugs, or forcing repeated edits
- `medium`: hurts readability or makes tests awkward
- `low`: noticeable noise with a clear mechanical cleanup

## Notes

- Prefer functions, data shape, and boundaries as the main units of change.
- If a smell sits at a runtime boundary, verify with tests before reorganizing it.
- If several smells are present, start with the one that creates the cleanest seam for the next change.
