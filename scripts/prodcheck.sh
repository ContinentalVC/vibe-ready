#!/usr/bin/env bash
set -euo pipefail

TARGET="."
STAGE="${VIBE_READY_STAGE:-private-beta}"
FORMAT="text"
FAIL_ON="none"
STAGE_EXPLICIT=0
MAX_HISTORY_COMMITS="${VIBE_READY_HISTORY_COMMITS:-300}"

usage() {
  cat <<'USAGE'
Vibe Ready - a friendly pre-production check for AI-built apps

Usage:
  scripts/prodcheck.sh [options] [target]

Options:
  --stage <stage>       prototype | private-beta | public-beta | production | enterprise
                        Default: private-beta (a few trusted users)
  --format <format>     text | json (default: text)
  --fail-on <level>     none | action (default: none)
  --strict              Same as --fail-on action; useful in CI
  -h, --help            Show this help

Examples:
  scripts/prodcheck.sh .
  scripts/prodcheck.sh --stage prototype .
  scripts/prodcheck.sh --stage public-beta --strict .
  scripts/prodcheck.sh --format json .

The default mode never blocks a build. It separates work into FIX NOW and
SAVE FOR LATER so early builders can improve safely without doing everything
at once.
USAGE
}

target_set=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    --stage)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --stage" >&2
        usage >&2
        exit 1
      fi
      STAGE="$2"
      STAGE_EXPLICIT=1
      shift 2
      ;;
    --format)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --format" >&2
        usage >&2
        exit 1
      fi
      FORMAT="$2"
      shift 2
      ;;
    --fail-on)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --fail-on" >&2
        usage >&2
        exit 1
      fi
      FAIL_ON="$2"
      shift 2
      ;;
    --strict)
      FAIL_ON="action"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [ "$target_set" -eq 1 ]; then
        echo "Only one target directory may be supplied" >&2
        exit 1
      fi
      TARGET="$1"
      target_set=1
      shift
      ;;
  esac
done

if [ "$#" -gt 0 ]; then
  if [ "$target_set" -eq 1 ] || [ "$#" -gt 1 ]; then
    echo "Only one target directory may be supplied" >&2
    exit 1
  fi
  TARGET="$1"
fi

case "$STAGE" in
  prototype|private-beta|public-beta|production|enterprise) ;;
  *)
    echo "Unknown stage: $STAGE" >&2
    echo "Expected one of: prototype, private-beta, public-beta, production, enterprise" >&2
    exit 1
    ;;
esac

case "$FORMAT" in
  text|json) ;;
  *)
    echo "Unknown format: $FORMAT (expected text or json)" >&2
    exit 1
    ;;
esac

case "$FAIL_ON" in
  none|action) ;;
  *)
    echo "Unknown --fail-on level: $FAIL_ON (expected none or action)" >&2
    exit 1
    ;;
esac

if [ ! -d "$TARGET" ]; then
  echo "Target is not a directory: $TARGET" >&2
  exit 2
fi

cd "$TARGET"
TARGET_ABS="$(pwd)"

stage_rank() {
  case "$1" in
    prototype) echo 1 ;;
    private-beta) echo 2 ;;
    public-beta) echo 3 ;;
    production) echo 4 ;;
    enterprise) echo 5 ;;
  esac
}

stage_plain_name() {
  case "$1" in
    prototype) echo "local prototype" ;;
    private-beta) echo "small private beta with trusted users" ;;
    public-beta) echo "public beta with open signups" ;;
    production) echo "production with real users or money" ;;
    enterprise) echo "enterprise or multi-tenant deployment" ;;
  esac
}

CURRENT_STAGE_RANK="$(stage_rank "$STAGE")"

RESULT_KINDS=()
RESULT_IDS=()
RESULT_MESSAGES=()
RESULT_EVIDENCE=()
RESULT_MIN_STAGES=()
ACTION_COUNT=0
LATER_COUNT=0
GOOD_COUNT=0
NOTE_COUNT=0

add_result() {
  local kind="$1"
  local id="$2"
  local message="$3"
  local evidence="${4:-}"
  local minimum_stage="${5:-}"
  RESULT_KINDS+=("$kind")
  RESULT_IDS+=("$id")
  RESULT_MESSAGES+=("$message")
  RESULT_EVIDENCE+=("$evidence")
  RESULT_MIN_STAGES+=("$minimum_stage")
  case "$kind" in
    action) ACTION_COUNT=$((ACTION_COUNT + 1)) ;;
    later) LATER_COUNT=$((LATER_COUNT + 1)) ;;
    good) GOOD_COUNT=$((GOOD_COUNT + 1)) ;;
    note) NOTE_COUNT=$((NOTE_COUNT + 1)) ;;
  esac
}

missing_result() {
  local id="$1"
  local minimum_stage="$2"
  local message="$3"
  local evidence="${4:-}"
  local minimum_rank
  minimum_rank="$(stage_rank "$minimum_stage")"
  if [ "$CURRENT_STAGE_RANK" -ge "$minimum_rank" ]; then
    add_result "action" "$id" "$message" "$evidence" "$minimum_stage"
  else
    add_result "later" "$id" "$message" "Needed from $minimum_stage onward${evidence:+; $evidence}" "$minimum_stage"
  fi
}

has_any() {
  local path
  for path in "$@"; do
    if [ -e "$path" ]; then
      return 0
    fi
  done
  return 1
}

has_runtime_code() {
  if has_any src app pages server api cmd lib scripts/prodcheck.sh package.json pyproject.toml requirements.txt go.mod Cargo.toml Gemfile composer.json; then
    return 0
  fi
  find . -maxdepth 4 \
    \( -path './.git' -o -path './node_modules' -o -path './vendor' -o -path './dist' -o -path './build' \) -prune -o \
    -type f \( -iname '*.js' -o -iname '*.jsx' -o -iname '*.ts' -o -iname '*.tsx' -o -iname '*.py' -o -iname '*.go' -o -iname '*.rs' -o -iname '*.rb' -o -iname '*.php' -o -iname '*.sh' \) -print -quit | grep -q .
}

runtime_content_matches() {
  local pattern="$1"
  if command -v rg >/dev/null 2>&1; then
    rg -l -i --hidden \
      --glob '!node_modules/**' --glob '!.git/**' --glob '!vendor/**' --glob '!dist/**' --glob '!build/**' \
      --glob '!checklists/**' --glob '!prompts/**' --glob '!templates/**' --glob '!examples/**' \
      --glob '!README*' --glob '!AGENTS.md' --glob '!ACKNOWLEDGMENTS.md' --glob '!ROADMAP.md' \
      --glob '!tests/**' --glob '!scripts/prodcheck.sh' \
      "$pattern" . 2>/dev/null | sed -n '1,5p'
  else
    return 1
  fi
}

secret_pattern='sk_live_|pk_live_|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|OPENAI_API_KEY=sk-|ANTHROPIC_API_KEY=sk-'
secret_scan_file="${TMPDIR:-/tmp}/vibe-ready-secret-scan-$$.txt"

# Invoked by the EXIT trap below.
# shellcheck disable=SC2329
cleanup() {
  rm -f "$secret_scan_file" "$secret_scan_file".err "$secret_scan_file".history "$secret_scan_file".history.err "$secret_scan_file".revs
}
trap cleanup EXIT

# Dependency and deterministic build checks.
if has_any package.json pyproject.toml requirements.txt go.mod Cargo.toml Gemfile composer.json; then
  add_result "good" "deps.manifest" "A dependency manifest was found." "project root"
else
  add_result "note" "deps.manifest" "No package-managed runtime was detected. That is normal for documentation-only or shell-only projects." "project root"
fi

if [ -f package.json ]; then
  if has_any package-lock.json npm-shrinkwrap.json pnpm-lock.yaml yarn.lock bun.lock bun.lockb; then
    add_result "good" "deps.js-lockfile" "JavaScript dependencies have a lockfile." "project root"
  else
    missing_result "deps.js-lockfile" "private-beta" "Create and commit the JavaScript lockfile so deploys install reviewed versions." "package.json exists"
  fi
fi

if [ -f pyproject.toml ]; then
  if has_any uv.lock poetry.lock pdm.lock; then
    add_result "good" "deps.python-lockfile" "Python dependencies have a recognized lockfile." "project root"
  else
    missing_result "deps.python-lockfile" "private-beta" "Confirm Python production dependencies are pinned; add a lockfile when the chosen tool supports one." "pyproject.toml exists"
  fi
fi

if [ -f requirements.txt ]; then
  if grep -Eq '^[A-Za-z0-9_.-]+==' requirements.txt; then
    add_result "good" "deps.requirements-pinned" "requirements.txt contains pinned dependencies." "requirements.txt"
  else
    missing_result "deps.requirements-pinned" "private-beta" "Pin production dependencies in requirements.txt or use a lockfile." "requirements.txt"
  fi
fi

# Environment files and secret hygiene.
if has_any .env.example .env.sample .env.template templates/env.example; then
  add_result "good" "config.env-example" "An environment-variable example is available." "project root or templates/"
elif has_runtime_code; then
  missing_result "config.env-example" "private-beta" "Add an env example with variable names and safe placeholder values." "no env example found"
fi

env_files="$(find . -maxdepth 4 \
  \( -path './.git' -o -path './node_modules' -o -path './vendor' -o -path './dist' -o -path './build' \) -prune -o \
  -type f \( -name '.env' -o -name '.env.*' \) \
  ! -name '.env.example' ! -name '.env.sample' ! -name '.env.template' -print 2>/dev/null | sed -n '1,20p')"
if [ -n "$env_files" ]; then
  tracked_env_files=""
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    while IFS= read -r env_file; do
      [ -n "$env_file" ] || continue
      if git ls-files --error-unmatch "${env_file#./}" >/dev/null 2>&1; then
        tracked_env_files="${tracked_env_files}${tracked_env_files:+, }${env_file#./}"
      fi
    done <<EOF
$env_files
EOF
  fi
  if [ -n "$tracked_env_files" ]; then
    add_result "action" "secrets.tracked-env" "Remove tracked environment files from Git and rotate any credentials they contained." "$tracked_env_files" "prototype"
  else
    add_result "note" "secrets.local-env" "Local environment files exist and are not tracked. Keep them out of Git." "$(echo "$env_files" | tr '\n' ' ')"
  fi
fi

if [ -f .gitignore ]; then
  if grep -Eq '(^|/)[.]env([*]|$)|[.]env[*]' .gitignore; then
    add_result "good" "secrets.env-ignore" "Git ignore rules appear to cover environment files." ".gitignore"
  else
    missing_result "secrets.env-ignore" "prototype" "Update .gitignore so .env and .env.* files cannot be committed accidentally." ".gitignore"
  fi
elif has_runtime_code; then
  missing_result "secrets.env-ignore" "prototype" "Add a .gitignore that excludes .env and .env.* files." "no .gitignore found"
fi

# Database and test indicators are conditional so simple sites are not pushed into unnecessary infrastructure.
db_evidence="$(runtime_content_matches '(DATABASE_URL|prisma|drizzle|supabase|sqlalchemy|mongoose|knex|diesel::|ActiveRecord)' || true)"
if [ -n "$db_evidence" ] || find . -maxdepth 4 -type d \( -iname migrations -o -iname prisma -o -iname drizzle -o -iname supabase \) -print -quit | grep -q .; then
  if find . -maxdepth 5 -type d \( -iname migrations -o -iname prisma -o -iname drizzle -o -iname supabase \) -print -quit | grep -q .; then
    add_result "good" "data.migrations" "A possible migration or database-definition directory was found." "database-related directory"
  else
    missing_result "data.migrations" "private-beta" "Add version-controlled database migrations before storing user-created data." "$db_evidence"
  fi
else
  add_result "note" "data.migrations" "No database usage was detected, so migrations are not being required." "conditional check"
fi

if has_runtime_code; then
  if find . -maxdepth 5 \
    \( -path './.git' -o -path './node_modules' -o -path './vendor' \) -prune -o \
    -type f \( -path '*/test/*' -o -path '*/tests/*' -o -iname '*_test.*' -o -iname '*.spec.*' -o -iname '*.test.*' \) -print -quit | grep -q .; then
    add_result "good" "quality.tests" "Tests were found." "test/spec file"
  else
    missing_result "quality.tests" "private-beta" "Add at least one automated test for the most important user journey and one failure path." "no tests found"
  fi
fi

# Feature detection uses code/dependency content as well as filenames and excludes Vibe Ready guidance files.
payment_evidence="$(runtime_content_matches '(stripe|paddle|lemonsqueezy|braintree|checkout[.]session|payment_intent|webhook.*signature)' || true)"
if [ -z "$payment_evidence" ]; then
  payment_evidence="$(find . -maxdepth 5 \
    \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' -o -path './examples' -o -path './tests' \) -prune -o \
    -type f \( -iname '*stripe*' -o -iname '*payment*' -o -iname '*webhook*' \) -print | sed -n '1,5p')"
fi
if [ -n "$payment_evidence" ]; then
  add_result "note" "feature.payments" "Payment or webhook code may be present. Use the payment checklist before accepting real money." "$payment_evidence"
else
  add_result "note" "feature.payments" "No payment implementation was detected." "conditional check"
fi

ai_evidence="$(runtime_content_matches '(@anthropic-ai|anthropic|openai|@google/generative-ai|bedrock-runtime|langchain|llamaindex|model[.]generateContent|chat[.]completions)' || true)"
if [ -z "$ai_evidence" ]; then
  ai_evidence="$(find . -maxdepth 5 \
    \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' -o -path './examples' -o -path './tests' \) -prune -o \
    -type f \( -iname '*openai*' -o -iname '*anthropic*' -o -iname '*llm*' -o -iname '*mcp*' \) -print | sed -n '1,5p')"
fi
if [ -n "$ai_evidence" ]; then
  add_result "note" "feature.ai" "AI/model code may be present. Use the AI checklist before exposing it publicly." "$ai_evidence"
else
  add_result "note" "feature.ai" "No AI/model implementation was detected. Agent instruction files are intentionally ignored." "conditional check"
fi

messaging_evidence="$(runtime_content_matches '(resend|sendgrid|postmark|mailgun|nodemailer|ses[.]send|sendMail|send_email)' || true)"
if [ -z "$messaging_evidence" ]; then
  messaging_evidence="$(find . -maxdepth 5 \
    \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' -o -path './examples' -o -path './tests' \) -prune -o \
    -type f \( -iname '*email*' -o -iname '*mailer*' -o -iname '*notification*' \) -print | sed -n '1,5p')"
fi
if [ -n "$messaging_evidence" ]; then
  add_result "note" "feature.messaging" "Transactional messaging may be present. Check delivery, retries, and a support fallback." "$messaging_evidence"
else
  add_result "note" "feature.messaging" "No transactional-messaging implementation was detected." "conditional check"
fi

api_contract_evidence="$(find . -maxdepth 5 \
  \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' \) -prune -o \
  -type f \( -iname 'openapi*.yaml' -o -iname 'openapi*.yml' -o -iname 'openapi*.json' -o -iname 'swagger*.yaml' -o -iname 'swagger*.yml' -o -iname 'swagger*.json' -o -iname 'asyncapi*.yaml' -o -iname 'asyncapi*.yml' -o -iname 'asyncapi*.json' \) -print | sed -n '1,5p')"
if [ -n "$api_contract_evidence" ]; then
  add_result "note" "feature.api-contract" "An API contract was found. Verify implementation compatibility and authorization in CI." "$api_contract_evidence"
else
  add_result "note" "feature.api-contract" "No OpenAPI, Swagger, or AsyncAPI contract was detected. This is optional unless other consumers depend on the API." "conditional check"
fi

if find . -maxdepth 4 -type f \( -iname Dockerfile -o -iname docker-compose.yml -o -iname docker-compose.yaml \) -print -quit | grep -q .; then
  add_result "note" "platform.container" "Container configuration was found; review image pinning, health checks, and resource limits." "Docker configuration"
fi

if find . -maxdepth 4 -type f \( -iname '*.graphql' -o -iname schema.graphqls -o -iname 'gqlconfig*' \) -print -quit | grep -q .; then
  add_result "note" "api.graphql" "GraphQL was found; review depth, complexity, pagination, and authorization limits." "GraphQL schema"
fi

if find . -maxdepth 4 \
  \( -type d \( -iname kubernetes -o -iname k8s \) -o -type f \( -iname kustomization.yaml -o -iname deployment.yaml -o -iname deployment.yml \) \) \
  -print -quit | grep -q .; then
  add_result "note" "platform.kubernetes" "Kubernetes configuration was found; review probes, resource limits, workload identity, and network policy." "Kubernetes configuration"
fi

# Lightweight working-tree secret scan.
if command -v rg >/dev/null 2>&1; then
  set +e
  rg -n --hidden --glob '!node_modules/**' --glob '!.git/**' --glob '!dist/**' --glob '!build/**' \
    --glob '!scripts/prodcheck.sh' --glob '!tests/**' "$secret_pattern" . >"$secret_scan_file" 2>"${secret_scan_file}.err"
  scan_status=$?
  set -e
else
  set +e
  grep -REn --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build \
    --exclude=prodcheck.sh "$secret_pattern" . >"$secret_scan_file" 2>"${secret_scan_file}.err"
  scan_status=$?
  set -e
fi

if [ "$scan_status" -eq 0 ]; then
  add_result "action" "secrets.working-tree" "Possible live-secret patterns were found. Verify them, remove real secrets, and rotate exposed credentials." "$(sed -n '1,10p' "$secret_scan_file" | tr '\n' ' ')" "prototype"
elif [ "$scan_status" -eq 1 ]; then
  add_result "good" "secrets.working-tree" "No high-signal secret patterns were found in the working tree." "lightweight scan"
else
  add_result "action" "secrets.working-tree" "The working-tree secret scan failed; do not assume the project is clean." "$(sed -n '1,5p' "${secret_scan_file}.err" | tr '\n' ' ')" "prototype"
fi

# Bounded Git history scan. This remains intentionally lightweight.
if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  : >"$secret_scan_file.history"
  : >"${secret_scan_file}.history.err"
  git rev-list --all --max-count="$MAX_HISTORY_COMMITS" >"$secret_scan_file.revs"
  scanned_revs="$(wc -l <"$secret_scan_file.revs" | tr -d ' ')"
  total_revs="$(git rev-list --all --count)"
  set +e
  history_scan_error=0
  while IFS= read -r rev; do
    git grep -n -E "$secret_pattern" "$rev" -- . ':(exclude)scripts/prodcheck.sh' ':(exclude)tests' >>"$secret_scan_file.history" 2>>"${secret_scan_file}.history.err"
    git_grep_status=$?
    if [ "$git_grep_status" -gt 1 ]; then
      history_scan_error=1
    fi
  done <"$secret_scan_file.revs"
  set -e
  if [ "$history_scan_error" -ne 0 ]; then
    add_result "action" "secrets.git-history" "The Git-history secret scan failed; do not assume history is clean." "$(sed -n '1,5p' "${secret_scan_file}.history.err" | tr '\n' ' ')" "prototype"
  elif [ -s "$secret_scan_file.history" ]; then
    add_result "action" "secrets.git-history" "Possible secret patterns were found in Git history. Verify, rotate, and remove real credentials." "$(sed -n '1,10p' "$secret_scan_file.history" | tr '\n' ' ')" "prototype"
  else
    add_result "good" "secrets.git-history" "No high-signal secret patterns were found in the scanned Git history." "$scanned_revs of $total_revs commits scanned"
  fi
  if [ "$total_revs" -gt "$scanned_revs" ]; then
    add_result "note" "secrets.history-depth" "The history scan is intentionally bounded. Use VIBE_READY_HISTORY_COMMITS or a dedicated scanner for deeper forensics." "$scanned_revs of $total_revs commits scanned"
  fi
fi

json_escape() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  printf '%s' "$value"
}

render_text() {
  echo "Vibe Ready"
  echo "Project: $TARGET_ABS"
  echo "Today we are checking for a $(stage_plain_name "$STAGE")."
  if [ "$STAGE_EXPLICIT" -eq 0 ]; then
    echo "Using the beginner-friendly private-beta default. Change it with --stage when needed."
  fi
  echo
  echo "Fix now"
  if [ "$ACTION_COUNT" -eq 0 ]; then
    echo "  Nothing obvious from the lightweight scan. An agent/code review is still required."
  else
    local i
    for ((i=0; i<${#RESULT_IDS[@]}; i++)); do
      if [ "${RESULT_KINDS[$i]}" = action ]; then
        echo "  [FIX NOW] ${RESULT_MESSAGES[$i]}"
        echo "            id=${RESULT_IDS[$i]}${RESULT_EVIDENCE[$i]:+ | evidence=${RESULT_EVIDENCE[$i]}}"
      fi
    done
  fi
  echo
  echo "Good signs"
  local i
  for ((i=0; i<${#RESULT_IDS[@]}; i++)); do
    if [ "${RESULT_KINDS[$i]}" = good ]; then
      echo "  [GOOD] ${RESULT_MESSAGES[$i]}"
    fi
  done
  echo
  if [ "$LATER_COUNT" -gt 0 ]; then
    echo "Save for later"
    for ((i=0; i<${#RESULT_IDS[@]}; i++)); do
      if [ "${RESULT_KINDS[$i]}" = later ]; then
        echo "  [LATER] ${RESULT_MESSAGES[$i]}"
        echo "          ${RESULT_EVIDENCE[$i]}"
      fi
    done
    echo
  fi
  echo "Helpful notes"
  for ((i=0; i<${#RESULT_IDS[@]}; i++)); do
    if [ "${RESULT_KINDS[$i]}" = note ]; then
      echo "  [NOTE] ${RESULT_MESSAGES[$i]}${RESULT_EVIDENCE[$i]:+ | ${RESULT_EVIDENCE[$i]}}"
    fi
  done
  echo
  echo "Summary: $ACTION_COUNT fix now, $LATER_COUNT saved for later, $GOOD_COUNT good signs."
  echo "Next: give this output, AGENTS.md, and checklists/quick-start.md to your coding agent."
}

render_json() {
  printf '{"tool":"vibe-ready","stage":"%s","target":"%s","summary":{"actions":%s,"later":%s,"good":%s,"notes":%s},"checks":[' \
    "$(json_escape "$STAGE")" "$(json_escape "$TARGET_ABS")" "$ACTION_COUNT" "$LATER_COUNT" "$GOOD_COUNT" "$NOTE_COUNT"
  local i
  for ((i=0; i<${#RESULT_IDS[@]}; i++)); do
    if [ "$i" -gt 0 ]; then
      printf ','
    fi
    printf '{"id":"%s","status":"%s","minimum_stage":"%s","message":"%s","evidence":"%s"}' \
      "$(json_escape "${RESULT_IDS[$i]}")" \
      "$(json_escape "${RESULT_KINDS[$i]}")" \
      "$(json_escape "${RESULT_MIN_STAGES[$i]}")" \
      "$(json_escape "${RESULT_MESSAGES[$i]}")" \
      "$(json_escape "${RESULT_EVIDENCE[$i]}")"
  done
  printf ']}\n'
}

if [ "$FORMAT" = json ]; then
  render_json
else
  render_text
fi

if [ "$FAIL_ON" = action ] && [ "$ACTION_COUNT" -gt 0 ]; then
  exit 3
fi
exit 0
