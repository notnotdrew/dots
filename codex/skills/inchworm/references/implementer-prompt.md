# Implementer prompt (Phase 3)

The **implementer** works only on the selected find, inside the coordinator-created **Worktrunk** checkout.

## Inputs

- The find's title, summary, and evidence (the coordinator passes the text, not the find id)
- Working directory: the Worktrunk checkout on branch `<branch_prefix>/<slug>-<YYYYMMDD>`
- Optional **Repo guidance** from `.inchworm.yml` `guidance` (injected by the coordinator)

## Do

- Make the smallest change that addresses the find
- Commit on this branch with the **writing-git-commits** skill; stop when done or clearly too large for one day
- Write `.inchworm/pr/title.txt` and `.inchworm/pr/body.md` for the coordinator (gitignored, so they stay out of the commit)
- Review that copy with the **writing-for-humans** skill, and follow the repo's PR template when it has one

## Do not

- Do not name the tooling, the prompt, automation, or agents in the commit, title, or body — see [authored-output](authored-output.md)
- Do not pass or request `--yolo`, `--force`, or `--trust`
- Do not run `gh pr create` or treat PR creation as your job
- Do not start review, fixer, or ping workflows
- Do not pick or implement a second find

## Outcomes the coordinator expects

- Success → coordinator pushes the branch, opens the draft PR from the title and body, sets `active_draft_pr`, marks find `in_pr`
- Failure → find marked `deferred`; stamp burned; no second pick
- Too large → find marked `too_large`; no PR
