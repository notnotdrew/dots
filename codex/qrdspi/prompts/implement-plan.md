# QRDSPI Implement Plan Stage

Use the runner contract below.

Treat the plan artifact as the execution source of truth.
Execute exactly one approved phase and update the plan artifact in place.
If the phase is blocked, incomplete, or waiting on manual work, record that state and stop.
Do not start the next phase here.
