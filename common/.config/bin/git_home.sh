#!/usr/bin/env bash

set -euo pipefail

git_main_branch() {
  if git show-ref --verify --quiet refs/heads/main; then
    printf '%s\n' "main"
    return
  fi

  if git show-ref --verify --quiet refs/heads/master; then
    printf '%s\n' "master"
    return
  fi

  git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@'
}

delete_gone_branches() {
  local current_branch gone_branch

  current_branch="$(git branch --show-current)"

  git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
    | while read -r gone_branch tracking; do
        if [[ "$tracking" == "[gone]" && "$gone_branch" != "$current_branch" ]]; then
          git branch -d "$gone_branch"
        fi
      done
}

main_branch="$(git_main_branch)"

if [[ -z "$main_branch" ]]; then
  printf '%s\n' "Could not determine the main branch for this repository." >&2
  exit 1
fi

git checkout "$main_branch"
git pull
git remote prune origin
delete_gone_branches
