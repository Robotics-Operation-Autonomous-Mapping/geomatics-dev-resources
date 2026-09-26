# Git & GitHub workshop (~45 min)

Facilitator guide for a short hands-on session: what Git is, the everyday commands, and how we ship work on this team (branch → commit → push → PR).

Use this as a **script**. Times are approximate — skip the stretch section if you run long.

---

## Goals (by the end, everyone can)

1. Explain **working tree → staging → commit → remote** in plain language
2. Run: `status`, `add`, `commit`, `log`, `branch`, `checkout`/`switch`, `push`, `pull`
3. Open a **Pull Request** on GitHub (no direct push to `main`)

Team rule reminder: [rules.md](rules.md) — branch → PR → review → merge.

---

## Before the session (you)

| Prep | Notes |
|------|--------|
| Everyone has a GitHub account | Org invite already sent if using this private repo |
| Git installed | `git --version` works on each laptop |
| Optional sandbox | Create a throwaway public repo `git-workshop-practice` so nobody fears breaking onboarding |
| Whiteboard / slide | One diagram: Working copy → Staging → Local repo → GitHub |

**Suggested sandbox:** each person forks (or you give them write access to) a tiny practice repo with a single `hello.txt`. Avoid using `geomatics-dev-resources` `main` as the playground.

---

## Agenda

| Min | Block | What you do |
|-----|--------|-------------|
| 0–5 | Mental model | Diagram + 3 questions |
| 5–15 | Local loop | `status` / `add` / `commit` / `log` |
| 15–25 | Branches | Why branches; create one; switch |
| 25–35 | GitHub | `push`, open PR, review UI |
| 35–42 | Team workflow | Our rules + common mistakes |
| 42–45 | Cheat sheet + Q&A | Hand out command sheet |

---

## 0–5 min — Mental model

### Say this

> Git is a **time machine for your files**. GitHub is where the team **shares** those histories.
>
> You do not “save to GitHub.” You make a **snapshot locally** (commit), then **publish** it (push).

### Draw (or show) four boxes

```
[ Working files ]  --git add-->  [ Staging ]  --git commit-->  [ Local history ]
                                                                      |
                                                                  git push
                                                                      v
                                                              [ GitHub remote ]
```

### Check understanding (ask out loud)

1. Where does a commit live first — laptop or GitHub? → **Laptop**
2. What does `add` do? → **Select what goes into the next snapshot**
3. What does `push` do? → **Upload commits you already made**

---

## 5–15 min — Local loop (everyone types)

Have them open a terminal in the practice repo (or a fresh folder).

### 1. See where you are

```bash
git status
```

**Talk track:** “Git always answers: what’s changed, what’s staged, what branch am I on?”

### 2. Make a tiny change

Edit `hello.txt` (or create it):

```text
Workshop: I was here.
```

```bash
git status
```

They should see the file as **modified** or **untracked**.

### 3. Stage

```bash
git add hello.txt
# or stage everything in the folder (careful on real projects):
# git add .
git status
```

**Talk track:** Staging = shopping cart. Commit = checkout. You can add only some files.

### 4. Commit

```bash
git commit -m "Add workshop hello note"
```

If Git complains about name/email (first time on a machine):

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Then run the commit again.

**Talk track:** A commit message answers *why*, not a dump of file names. Short and clear is enough for now.

### 5. See history

```bash
git log --oneline -5
```

**Talk track:** Each line is a snapshot with an ID. You can always go back.

### Mini exercise (2 min)

- Change `hello.txt` again
- `git add` → `git commit -m "…"`
- Show `git log --oneline -3` to a neighbor

---

## 15–25 min — Branches

### Say this

> `main` is the shared “known good” line. Feature work happens on a **branch** so we don’t step on each other.
>
> On this team: **never push straight to `main`.** Open a PR.

### Commands

```bash
# See branches (* = current)
git branch

# Create + switch (modern)
git switch -c workshop/<your-name>

# Older equivalent still common:
# git checkout -b workshop/<your-name>

git status   # should show the new branch name
```

Make one more edit, then:

```bash
git add hello.txt
git commit -m "Update hello from my workshop branch"
```

### Optional demo (you do it live)

```bash
git switch main
# show hello.txt content — their new commit is not here
git switch workshop/<your-name>
# content is back
```

**Talk track:** Commits belong to a branch line. Switching changes which line you’re on.

---

## 25–35 min — GitHub: push + Pull Request

### First-time remote check

```bash
git remote -v
```

If they’re in a clone, `origin` should already point at GitHub. If you started from an empty folder:

```bash
git remote add origin https://github.com/<org-or-user>/<practice-repo>.git
```

### Push the branch

```bash
git push -u origin HEAD
```

`-u` links this local branch to the remote branch so later they can just `git push` / `git pull`.

### Open a PR (browser)

1. Open the repo on GitHub — yellow banner: **Compare & pull request**, or **Pull requests → New**
2. Base: `main` ← compare: `workshop/<name>`
3. Title + short description (what / why)
4. Create pull request

### What to show on the PR page

- Files changed
- Commits
- “Conversation” (where review comments go)
- Merge button (say: **only after review** on real work)

**Live demo:** leave one friendly review comment on someone’s PR (“Looks good — please rename X”). That’s the habit required for checkpoints later.

### Pull others’ updates (concept)

```bash
git switch main
git pull
```

**Talk track:** `pull` = download new commits from GitHub into your current branch. Do this before starting new work so you’re not behind.

---

## 35–42 min — How we work on ROAM

Walk [rules.md](rules.md) Git section out loud:

| Do | Don’t |
|----|--------|
| Branch named like `cp1/<name>-imu-attitude` | Commit huge bags / secrets / maps |
| PR → review → merge | Push directly to `main` |
| Resolve at least one review comment (CP1+) | Giant “fix everything” commits with no message |

### Common mistakes (30 seconds each)

| Symptom | Likely cause | Fix idea |
|---------|----------------|----------|
| “Your branch is ahead of origin” | Committed but not pushed | `git push` |
| “Please tell me who you are” | Missing `user.name` / `user.email` | `git config --global …` |
| Dirty `git status` forever | Forgot `add` or leftover junk | `status` → add what you want; don’t force-add secrets |
| Can’t push to `main` | Branch protection (good!) | Push a feature branch + PR |
| Merge conflicts | Two edits to same lines | Open the file, fix markers, `add`, `commit` |

Do **not** teach `force push` or rewriting shared history in this session.

---

## 42–45 min — Cheat sheet (leave on screen / print)

```bash
git status                 # where am I? what’s changed?
git diff                   # unstaged changes
git diff --staged          # what will be committed
git add <file>             # stage
git commit -m "message"    # snapshot
git log --oneline -10      # recent history

git switch -c <branch>     # create + switch branch
git switch <branch>        # switch existing
git branch                 # list branches

git pull                   # update current branch from GitHub
git push -u origin HEAD    # publish current branch (first time)
git push                   # publish again later

git remote -v              # where does origin point?
```

**One sentence to remember:**  
`status` → `add` → `commit` → `push` → open **PR**.

---

## Stretch (if you have time)

Only if everyone finished early (~5 min):

1. Someone else requests a small change on a PR
2. Author edits locally, `add`, `commit`, `push` — PR updates automatically
3. Mention `git restore <file>` to discard unstaged local edits (careful: throws away work)

---

## Facilitator tips

- **Type with them**, don’t only slide-deck. Muscle memory > vocabulary.
- If Windows users struggle with Git Bash vs PowerShell, pick **one** shell for the room and stick to it.
- Auth: HTTPS may prompt a browser login / personal access token; SSH needs keys. Budget 2–3 min if someone hits auth walls — pair them with a neighbor who already pushed.
- Keep the practice repo disposable. Real onboarding work still follows checkpoint branch names and the PR template: [.github/PULL_REQUEST_TEMPLATE.md](../.github/PULL_REQUEST_TEMPLATE.md).

---

## After the workshop (optional homework)

1. Clone [geomatics-dev-resources](https://github.com/Robotics-Operation-Autonomous-Mapping/geomatics-dev-resources) (after org access)
2. Create branch `workshop/<name>-notes`
3. Add one line to a personal notes file **only if leads say that path is OK** — or keep practice in the sandbox repo
4. Open a PR and get one review comment resolved

Next stop for the track: [00-setup.md](00-setup.md).
