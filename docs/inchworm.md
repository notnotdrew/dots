# Inchworm

One small change per weekday. It opens a draft PR and then stops.

## Why it exists

- Small cleanups never earn a ticket, so they sit in the repo for years.
- An agent can do one a day without needing attention.
- Every PR has to be small and leave behavior alone. That cap is the point.

> Make the change easy, then make the easy change. —Kent Beck

- Inchworm only does the second half.
- If a find needs a refactor first, it marks the find `too_large` and quits for the day.
- Lots of days it makes nothing. Good. The other option is a 600-line PR nobody reads.
- The scary day is the one where it thinks something big is small. So far it stops.
- Doing the refactor as its own daily PR is not built yet.

## How a day runs

- A LaunchAgent runs gated `inchworm run` every 30 minutes, weekdays 8:00 to 15:30. `inchworm now` is the same core without those gates.
- Each repo gets a gitignored `.inchworm.yml`: notes the agents have to follow, the last run date, the open draft URL.
- One find a day, one open draft. Miss a day and it stays missed.

1. **Scout.** Four agents go looking: code smells, lint, production errors, the backlog.
2. **Curate.** Fold the duplicates into `finds.md`, rank them, keep 20.
3. **Pick.** The top one, or none.
4. **Implement.** A Worktrunk checkout, dated branch off the freshly fetched trunk.
5. **Open the PR.** Draft, against the trunk the repo names in `base_branch`.
6. **Review.** One review pass, one fix pass for real blockers, squashed into one commit.
7. **Notify.** A notification with the link.

Two early mistakes:

- Stamp the date before writing any code. Otherwise a crash tries again on a different find and produces two PRs.
- Keep the tool's name out of the branch, the commit, and the PR title. The body ends with one line linking here: Picked and implemented by inchworm.

## Things it won't do

- Merge, or mark a draft ready. A human does that.
- Open a second draft while one is still out.
- Loop review against fix. One pass each.
- Pass `--yolo`, `--force`, or `--trust` to any agent.
- Make the change bigger to fit the find.

---

Built over a few evenings. Runs on a laptop against a couple of repos.
