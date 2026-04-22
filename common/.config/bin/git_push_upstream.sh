#!/usr/bin/env bash

set -euo pipefail

git_current_branch() {
  git branch --show-current
}

current_branch="$(git_current_branch)"

if [[ -z "$current_branch" ]]; then
  printf '%s\n' "You must be on a branch to push upstream." >&2
  exit 1
fi

git push --set-upstream origin "$current_branch"
