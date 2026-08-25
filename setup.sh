#!/usr/bin/env bash
#
# GH-900 Class Handbook — one-shot setup.
#
#   1. Creates the repository on GitHub
#   2. Pushes the seed files
#   3. Creates one "Add a handbook page for <name>" issue per learner
#   4. Turns on GitHub Pages
#
# Usage:
#   ./setup.sh                          # uses roster.txt, repo name gh900-class-handbook
#   ./setup.sh --repo my-class-name     # different repo name
#   ./setup.sh --roster names.txt       # different roster file
#   ./setup.sh --private                # private repo (note: Pages needs a paid plan)
#   ./setup.sh --dry-run                # show what would happen, change nothing
#
# Requires: gh (authenticated) and git.

set -euo pipefail

REPO="gh900-class-handbook"
ROSTER="roster.txt"
VISIBILITY="--public"
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)    REPO="$2"; shift 2 ;;
    --roster)  ROSTER="$2"; shift 2 ;;
    --private) VISIBILITY="--private"; shift ;;
    --public)  VISIBILITY="--public"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

say()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }
die()  { printf '\033[1;31mXX\033[0m  %s\n' "$*" >&2; exit 1; }
run()  { if [[ $DRY_RUN -eq 1 ]]; then printf '   would run: %s\n' "$*"; else "$@"; fi; }

# ---------- preflight ----------

command -v gh  >/dev/null || die "gh is not installed. See https://cli.github.com"
command -v git >/dev/null || die "git is not installed."
gh auth status >/dev/null 2>&1 || die "gh is not authenticated. Run: gh auth login"

OWNER="$(gh api user --jq .login)"
say "Authenticated as $OWNER"

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  die "Repository $OWNER/$REPO already exists. Pick another name with --repo, or delete it first."
fi

# A roster is optional. Without one, learners open their own issue from the
# template at the start of class — one click, and it teaches issue creation.
LEARNER_COUNT=0
if [[ -f "$ROSTER" ]]; then
  LEARNER_COUNT=$(grep -vE '^\s*(#|$)' "$ROSTER" | wc -l | tr -d ' ')
fi

echo
say "About to create:"
echo "    repository : $OWNER/$REPO  (${VISIBILITY#--})"
if [[ "$LEARNER_COUNT" -gt 0 ]]; then
  echo "    issues     : $LEARNER_COUNT (from $ROSTER)"
else
  echo "    issues     : none — learners open their own from the template"
fi
echo "    pages      : enabled from main branch"
echo
if [[ $DRY_RUN -eq 1 ]]; then
  warn "Dry run — nothing will be changed."
else
  read -r -p "Continue? [y/N] " reply
  [[ "$reply" =~ ^[Yy]$ ]] || die "Cancelled."
fi
echo

# ---------- 1. personalise CODEOWNERS ----------

if [[ -f CODEOWNERS ]] && grep -q 'INSTRUCTOR-USERNAME' CODEOWNERS; then
  say "Setting CODEOWNERS to @$OWNER"
  if [[ $DRY_RUN -eq 0 ]]; then
    sed -i.bak "s/INSTRUCTOR-USERNAME/$OWNER/g" CODEOWNERS && rm -f CODEOWNERS.bak
  fi
fi

# ---------- 2. create the repository ----------

say "Creating repository $OWNER/$REPO"
run gh repo create "$REPO" $VISIBILITY \
  --description "GH-900 GitHub Foundations — a handbook built live by the class." \
  --homepage "https://$OWNER.github.io/$REPO/"

# ---------- 3. push the seed files ----------

say "Pushing seed files"
if [[ $DRY_RUN -eq 0 ]]; then
  [[ -d .git ]] || git init -q -b main
  git add -A
  git commit -q -m "Seed the class handbook

Adds the repository skeleton the class will build on: README, contributing
guide with branch naming conventions, licence, security policy, code owners,
roster page, and issue and pull request templates." || true
  git branch -M main
  git remote remove origin 2>/dev/null || true
  git remote add origin "https://github.com/$OWNER/$REPO.git"
  git push -q -u origin main
else
  echo "   would run: git init / add / commit / push to $OWNER/$REPO"
fi

# ---------- 4. labels ----------

say "Creating labels"
run gh label create "handbook" --repo "$OWNER/$REPO" --color "0E8A16" --description "Class handbook page" --force
run gh label create "good first issue" --repo "$OWNER/$REPO" --color "7057FF" --description "Good for newcomers" --force

# ---------- 5. one issue per learner ----------

if [[ "$LEARNER_COUNT" -eq 0 ]]; then
  say "Skipping issues — learners will open their own from the template"
else
say "Creating $LEARNER_COUNT issues"
n=0
while IFS= read -r line; do
  [[ -z "${line// }" ]] && continue
  [[ "$line" =~ ^[[:space:]]*# ]] && continue

  name="${line%%,*}"
  team="${line#*,}"
  [[ "$team" == "$line" ]] && team="Blob"
  name="$(echo "$name" | xargs)"
  team="$(echo "$team" | xargs)"
  slug="$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/^-//;s/-$//' | cut -d- -f1)"
  n=$((n+1))

  body="## Your task

Add your own page to the class handbook, and add your row to the roster.

**Your team:** \`$team\`
**Your branch name:** \`docs/add-$slug-page\`

## Steps

- [ ] Assign this issue to yourself
- [ ] Create a branch called \`docs/add-$slug-page\`
- [ ] Add \`docs/$slug.md\`, starting from \`docs/_template.md\`
- [ ] Add your row to the **Team $team** table in \`index.md\`
- [ ] Open a pull request with \`Closes #<this issue number>\` in the description
- [ ] Request a review from your pair
- [ ] Review your pair's pull request and approve it
- [ ] Merge once approved

## Branch naming

Real teams name branches \`type/short-description\` — lowercase, hyphenated,
describing the work rather than the person. Today's change is documentation,
so yours is \`docs/add-$slug-page\`.

The full convention is in CONTRIBUTING.md. It is worth two minutes of your time.

## Stuck?

CONTRIBUTING.md walks through every step in order. Ask your pair first,
then the room, then the instructor."

  printf '   %2d/%s  %s (%s)\n' "$n" "$LEARNER_COUNT" "$name" "$team"
  if [[ $DRY_RUN -eq 0 ]]; then
    gh issue create --repo "$OWNER/$REPO" \
      --title "Add a handbook page for $name" \
      --body "$body" \
      --label "handbook" --label "good first issue" >/dev/null
  fi
done < "$ROSTER"
fi

# ---------- 6. GitHub Pages ----------

say "Enabling GitHub Pages"
if [[ $DRY_RUN -eq 0 ]]; then
  gh api -X POST "repos/$OWNER/$REPO/pages" \
    -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
    && echo "   Pages enabled." \
    || warn "Could not enable Pages automatically. Turn it on by hand: Settings → Pages → Source: main / root."
else
  echo "   would enable Pages from main / root"
fi

# ---------- done ----------

echo
say "Done."
echo
echo "  Repository : https://github.com/$OWNER/$REPO"
echo "  Issues     : https://github.com/$OWNER/$REPO/issues"
echo "  Live site  : https://$OWNER.github.io/$REPO/   (first build takes a minute or two)"
echo
echo "  Before class:"
echo "    - Invite learners: Settings → Collaborators → Add people"
echo "    - Pick two learners on the SAME team, sitting next to each other in the"
echo "      roster file: they will both edit adjacent lines of index.md and give"
echo "      you the planned merge conflict in Lab 2."
echo
