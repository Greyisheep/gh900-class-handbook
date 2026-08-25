# How to contribute

Everything here is done **in your browser**. Nothing to install. No terminal. No account beyond the GitHub login you already have.

---

## Step 1 — Claim your issue

Go to the [Issues](../../issues) tab. Find the one titled **"Add a handbook page for &lt;your name&gt;"**.

Open it. On the right-hand side, click **Assignees → assign yourself**.

> Why: assigning yourself is how a team avoids two people doing the same work. It's the smallest possible act of collaboration.

---

## Step 2 — Name your branch properly

This is the part most people get wrong for years, so we're doing it right from the first try.

At the top of the repository, click the branch dropdown (it says `main`). Type your branch name, then click **Create branch**.

Your branch name today is:

```
docs/add-<yourname>-page
```

For example: `docs/add-amara-page`

### The convention, and why it exists

Real teams name branches as **`type/short-description`**:

| Type | Use it for | Example |
| --- | --- | --- |
| `feat` | A new feature | `feat/export-to-csv` |
| `fix` | A bug fix | `fix/login-timeout` |
| `docs` | Documentation only | `docs/add-amara-page` |
| `chore` | Maintenance, dependencies, config | `chore/update-dependencies` |
| `refactor` | Restructuring without changing behaviour | `refactor/split-auth-module` |
| `test` | Adding or fixing tests | `test/cover-payment-edge-cases` |
| `hotfix` | An urgent fix going straight to production | `hotfix/payment-crash` |

Many teams add the ticket number too:

```
fix/1482-login-timeout
feat/PROJ-233-export-to-csv
```

### The rules

- **Lowercase only.** Some systems treat `Fix/Thing` and `fix/thing` as different branches. Mixed case causes real, confusing breakage.
- **Hyphens between words** — not spaces, not underscores. `add-amara-page`, never `add_amara_page` or `add amara page`.
- **Describe the work, not yourself.** `docs/add-amara-page` says what happens. `amaras-branch` says nothing to anyone reading the branch list in six months.
- **Keep it short.** Three or four words after the slash. The pull request title is where detail belongs.
- **No trailing slashes, no double slashes.**

### What to avoid, and why

| Don't | Why not |
| --- | --- |
| `test` | Test of what? Says nothing. |
| `mybranch`, `johns-branch` | Names the person, not the work. Useless once John leaves. |
| `new`, `final`, `final2`, `latest` | This is the `final_v2_FINAL.docx` problem, moved into Git. |
| `Fix-Login` | Mixed case and inconsistent separators. |
| `feature/thing-im-working-on-for-the-client-meeting-next-tuesday` | Nobody reads to the end of that. |

> The real point: a stranger should be able to read your branch list and understand what the team is working on, without asking anyone.

---

## Step 3 — Write your page

Make sure the branch dropdown still shows **your** branch, not `main`.

Go into the `docs/` folder → **Add file → Create new file**. Name it:

```
docs/<yourname>.md
```

Copy [`docs/_template.md`](docs/_template.md) as your starting point, then make it yours.

Use **at least five** of these:

- [ ] A heading (`#`, `##`)
- [ ] Bold (`**bold**`) or italic (`_italic_`)
- [ ] A bulleted or numbered list
- [ ] A link (`[text](url)`)
- [ ] A task list (like this one)
- [ ] A fenced code block
- [ ] A table
- [ ] An emoji (`:sparkles:`)

Commit to your branch with a real message — one that says **why**, not what:

```
Add handbook page for Amara
```

---

## Step 4 — Add yourself to the roster

Open [`index.md`](index.md) — still on your branch — and add your row to **your team's** table.

Keep the pipes and dashes intact.

> Heads up: if someone edits a line near yours before you merge, you'll hit a **merge conflict**. That's normal, it's not a mistake, and we're solving one together on the projector. Don't panic and don't delete anything.

---

## Step 5 — Open a pull request

**Pull requests → New pull request**

- **base:** `main` — **compare:** `docs/add-<yourname>-page`

In the description you **must** include this line, with your real issue number:

```
Closes #12
```

That keyword links the pull request to your issue and closes it automatically on merge. `Fixes` and `Resolves` behave identically.

---

## Step 6 — Review, and be reviewed

Request a review from your pair (sidebar → **Reviewers**).

Then review theirs:

1. Open their pull request → **Files changed**
2. Leave **at least one real comment**. "Nice heading" is fine. "This link is broken" is better.
3. **Review changes → Approve**

> Reviewing isn't about catching people out. It's how knowledge moves through a team, and it's the most common thing you'll do on GitHub for the rest of your career.

---

## Step 7 — Merge

Once approved, click **Merge pull request**.

Go back to your issue. It closed itself. That's `Closes #` working.

Delete the branch when prompted — it's done its job, and the history lives on in `main`.

---

## Finished early? Stay in this repo

No new tools, no new logins. Pick any of these — all in the browser, all here:

1. **Open a second pull request** on a properly named branch: `docs/fix-typo-in-readme`. Find a genuine typo anywhere in this repo and fix it.
2. **Review two more pull requests** that nobody has picked up yet. Leave a comment that actually helps.
3. **Rename practice** — look at the open branch list and write, in a comment on your issue, a better name for any branch that breaks the convention above.
4. **Open an issue** describing something missing from this handbook. Use a clear title and say what "done" would look like.
5. **Add labels and a milestone** to your own issue.
6. **Try `.`** — press the full-stop key anywhere in this repo. It opens a browser editor. Make an edit there and commit it.
7. **Answer someone's question in a pull request comment.** Teaching it is how you find out whether you know it.

---

## Stuck?

Ask your pair. Then the room. Then the instructor. In that order — it's how real teams work, and the answer usually turns up before step three.
