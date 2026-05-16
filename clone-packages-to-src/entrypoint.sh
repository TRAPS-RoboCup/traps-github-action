#!/usr/bin/env bash
set -euo pipefail

workspace="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
repo_name="${GITHUB_REPOSITORY##*/}"
repos_file="${INPUT_REPOS_FILE:-*.repos}"

token="${INPUT_TOKEN:-}"
if [[ -n "${token}" ]]; then
  git config --global url."https://${token}@github.com/".insteadOf "https://github.com/"
fi

mkdir -p "${workspace}/src/${repo_name}"

pushd "${workspace}/src/${repo_name}" >/dev/null
  git init
  git remote add origin "${GITHUB_SERVER_URL:-https://github.com}/${GITHUB_REPOSITORY}.git"
  git fetch --depth 1 origin "${GITHUB_SHA}"
  git checkout FETCH_HEAD
  git submodule update --init --recursive --depth 1
popd >/dev/null

repos_pattern="${workspace}/src/${repo_name}/${repos_file}"
shopt -s nullglob
matches=( ${repos_pattern} )
shopt -u nullglob

if [[ ${#matches[@]} -eq 0 ]]; then
  echo "No .repos file matched: ${repos_pattern}" >&2
  exit 1
fi
if [[ ${#matches[@]} -gt 1 ]]; then
  echo "Multiple .repos files matched: ${repos_pattern}" >&2
  printf '%s\n' "${matches[@]}" >&2
  exit 1
fi

vcs import --shallow --recursive "${workspace}/src" < "${matches[0]}"
