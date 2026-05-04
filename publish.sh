#!/usr/bin/env bash
# Publish trungtpham.github.io to GitHub.
#
# What this does, step by step:
#   1. Confirms your git identity (sets it locally for this repo only).
#   2. Initializes the repo on `main` if it isn't already.
#   3. Snapshots the current GitHub `main` (the old AcademicPages site)
#      into a remote branch called `legacy-jekyll` so nothing is lost.
#   4. Stages, commits, and force-publishes the new site to `main`.
#
# It's idempotent: rerunning will create a fresh commit without re-archiving.

set -euo pipefail

# ---- Settings ---------------------------------------------------------------
GIT_USER_NAME="Trung Pham"
GIT_USER_EMAIL="trung.ptt@gmail.com"      # change to trungp@nvidia.com if preferred
REPO_SSH="git@github.com:trungtpham/trungtpham.github.io.git"
REPO_HTTPS="https://github.com/trungtpham/trungtpham.github.io.git"
ARCHIVE_BRANCH="legacy-jekyll"

# ---- Choose remote URL ------------------------------------------------------
# Prefer SSH if you've set up GitHub SSH keys, otherwise HTTPS.
if ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 \
     | grep -q "successfully authenticated"; then
  REMOTE_URL="$REPO_SSH"
else
  REMOTE_URL="$REPO_HTTPS"
fi

cd "$(dirname "$0")"
echo "==> Project: $(pwd)"
echo "==> Remote:  $REMOTE_URL"
echo "==> Author:  $GIT_USER_NAME <$GIT_USER_EMAIL>"
echo

# ---- 1. Initialize repo if needed ------------------------------------------
# Also handles the case where .git exists but is incomplete/corrupt.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -e .git ]]; then
    echo "==> Found a broken .git — removing and reinitializing."
    rm -rf .git
  fi
  echo "==> git init -b main"
  git init -b main >/dev/null
fi

# Set per-repo identity (does not touch global ~/.gitconfig)
git config user.name  "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"

# ---- 2. Wire up the remote --------------------------------------------------
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

# ---- 3. Archive the old site to legacy-jekyll (one-time) -------------------
echo "==> Fetching current state of GitHub main…"
if git fetch origin main 2>/dev/null; then
  if git ls-remote --exit-code --heads origin "$ARCHIVE_BRANCH" >/dev/null 2>&1; then
    echo "    Archive branch '$ARCHIVE_BRANCH' already exists on remote — skipping."
  else
    echo "==> Archiving current main → $ARCHIVE_BRANCH"
    git push origin "refs/remotes/origin/main:refs/heads/$ARCHIVE_BRANCH"
    echo "    Old site safely backed up at: https://github.com/trungtpham/trungtpham.github.io/tree/$ARCHIVE_BRANCH"
  fi
else
  echo "    (no existing main branch on remote — skipping archive)"
fi

# ---- 4. Commit and push -----------------------------------------------------
git add -A

if git diff --cached --quiet; then
  echo "==> Nothing to commit."
else
  COMMIT_MSG="Refresh personal site

- Replace AcademicPages Jekyll setup with a minimal hand-written HTML/CSS site
- Update affiliation: NVIDIA Cosmos Lab (Principal Research Scientist)
- New News, Awards, Publications sections"
  git commit -m "$COMMIT_MSG"
fi

echo
echo "==> Force-publishing to origin/main…"
echo "    (Old site is preserved on the '$ARCHIVE_BRANCH' branch.)"
git push --force-with-lease origin main

echo
echo "==> Done. The site will be live at https://trungtpham.github.io/ in ~30–60 seconds."
echo "    If GitHub Pages isn't enabled, go to:"
echo "      https://github.com/trungtpham/trungtpham.github.io/settings/pages"
echo "    and set Source = Deploy from a branch, Branch = main, Folder = / (root)."
