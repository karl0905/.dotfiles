#!/usr/bin/env bash

set -euo pipefail

git_current_branch() {
  git branch --show-current
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

script_dir() {
  cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd
}

current_branch="$(git_current_branch)"

if [[ -z "$current_branch" ]]; then
  printf '%s\n' "You must be on a branch to open or create a pull request." >&2
  exit 1
fi

require_command gh
"$(script_dir)/git_push_upstream.sh"

if gh pr view --json url >/dev/null 2>&1; then
  gh pr view --web
else
  gh pr create --fill --web
fi
