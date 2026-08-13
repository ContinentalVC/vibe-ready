#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRODCHECK="$ROOT/scripts/prodcheck.sh"
TEST_TMP="$(mktemp -d "${TMPDIR:-/tmp}/vibe-ready-tests.XXXXXX")"
PASS_COUNT=0

cleanup() {
  rm -rf "$TEST_TMP"
}
trap cleanup EXIT

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
  echo "ok $PASS_COUNT - $1"
}

fail() {
  echo "not ok - $1" >&2
  exit 1
}

assert_contains() {
  local output="$1"
  local expected="$2"
  local label="$3"
  if ! grep -Fq "$expected" <<<"$output"; then
    echo "$output" >&2
    fail "$label (missing: $expected)"
  fi
  pass "$label"
}

new_js_fixture() {
  local name="$1"
  local dir="$TEST_TMP/$name"
  mkdir -p "$dir/src"
  printf '{"name":"fixture","private":true}\n' >"$dir/package.json"
  printf 'export const value = 1;\n' >"$dir/src/index.js"
  printf '.env*\n!.env.example\n' >"$dir/.gitignore"
  printf 'APP_URL=\n' >"$dir/.env.example"
  echo "$dir"
}

help_output="$($PRODCHECK --help)"
assert_contains "$help_output" "Default: private-beta" "help explains the friendly default"
assert_contains "$help_output" "The default mode never blocks a build" "help explains non-blocking behavior"

set +e
$PRODCHECK --stage unknown "$TEST_TMP" >/dev/null 2>&1
unknown_stage_status=$?
set -e
if [ "$unknown_stage_status" -ne 1 ]; then
  fail "unknown stage exits 1 (got $unknown_stage_status)"
fi
pass "unknown stages fail clearly"

lock_fixture="$(new_js_fixture lockfile)"
prototype_output="$($PRODCHECK --stage prototype "$lock_fixture")"
assert_contains "$prototype_output" "[LATER] Create and commit the JavaScript lockfile" "prototype defers the lockfile without hiding it"

public_output="$($PRODCHECK "$lock_fixture" --stage public-beta)"
assert_contains "$public_output" "[FIX NOW] Create and commit the JavaScript lockfile" "options work after the target and public beta requires a lockfile"

set +e
$PRODCHECK --stage public-beta --strict "$lock_fixture" >/dev/null
strict_status=$?
set -e
if [ "$strict_status" -ne 3 ]; then
  fail "strict mode exits 3 when actions exist (got $strict_status)"
fi
pass "strict mode is opt-in and enforceable"

ai_fixture="$(new_js_fixture ai-generic-route)"
printf 'import OpenAI from "openai"; export const client = new OpenAI();\n' >"$ai_fixture/src/route.js"
ai_output="$($PRODCHECK "$ai_fixture")"
assert_contains "$ai_output" "AI/model code may be present" "AI detection reads generic code files"

instructions_fixture="$TEST_TMP/agent-instructions-only"
mkdir -p "$instructions_fixture"
printf '# Agent instructions\nReview this app.\n' >"$instructions_fixture/AGENTS.md"
instructions_output="$($PRODCHECK "$instructions_fixture")"
assert_contains "$instructions_output" "No AI/model implementation was detected" "AGENTS.md alone is not classified as an AI app"

env_fixture="$(new_js_fixture tracked-env)"
printf 'DATABASE_PASSWORD=placeholder\n' >"$env_fixture/.env.local"
git -C "$env_fixture" init -q
git -C "$env_fixture" add .env.local -f
env_output="$($PRODCHECK "$env_fixture")"
assert_contains "$env_output" "Remove tracked environment files from Git" "tracked env variants are detected"

json_output="$($PRODCHECK --format json --stage prototype "$instructions_fixture")"
python3 -c 'import json,sys; data=json.load(sys.stdin); assert data["tool"] == "vibe-ready"; assert data["stage"] == "prototype"; assert all("minimum_stage" in item for item in data["checks"])' <<<"$json_output"
pass "JSON output is valid and machine-readable"

self_output="$($PRODCHECK --stage prototype "$ROOT")"
assert_contains "$self_output" "No AI/model implementation was detected" "self-check does not confuse guidance with AI implementation"

echo "1..$PASS_COUNT"
