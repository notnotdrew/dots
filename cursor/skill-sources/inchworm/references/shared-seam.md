# Shared-seam

Retry, discard, notify, and error classification are policy. If that policy already lives in a module more than one product or entry point uses, the find is `too_large` unless the patch stays next to the code that already owns the policy. A caller list does not earn safety. Putting the change where the policy already lives does.

Error-noise finds land here most often: the one-line version usually sits in a vendor adapter that everything else calls too. Extending a shared status or exception list is easy *because* the list is in the wrong place.

## The question

Who else would inherit a different retry, fail, or report meaning if this classification moved — including through a parent exception, a mixin, or another adapter that re-raises? If the answer is “I don’t know,” stop. Unknown blast radius is `too_large`.

## Why that question is enough

A job has entry points, not just callers. Enqueued and inline invocation are two entries into one job; retry and discard declarations apply to both, but an inline call does not wait for a re-enqueued retry.

Raising a `Transient*`, `Retryable*`, or domain error tells every caller “this is temporary” and hides the structured vendor error from callers that never opted in.

A unit spec proving the client does not notify says nothing about the job runner or the framework error reporter, which may report every attempt.

A recurring fault often means a user-visible side effect never happened. Muting the report without restoring the side effect is incomplete; restoring it by retrying inside a shared client can make other callers succeed with stale derived output. When both matter, the find is too large unless the seam already isolates the retrier.

If the honest fix is extract first — split entry points, move work out of the job, classify retries beside the code that retries — that is two changes. Mark `too_large` and stop. Do not ship the predicate in the shared module as a substitute. Later, those extract-only days are the north star (see SKILL.md); they are not today's process.

Thin is still allowed when the change stays in the layer that already owns the policy: turning a known vendor status or error string into a typed error, or recasting one message, next to the mapper that already does that work.

## Example

A shared HTTP adapter classifies responses as retryable by status. One job declares a retry on that classification, and another code path invokes the same job inline. Adding a status to the adapter's list is one line, and it changes retry, fail-loud, and reporting behavior for the inline entry point and for every other product calling that adapter. That find is `too_large`: the safe version first moves the classification next to the job that retries.

Mapping one known vendor error message to a typed error inside that job's own error mapper already sits with the policy owner and can still be thin.
