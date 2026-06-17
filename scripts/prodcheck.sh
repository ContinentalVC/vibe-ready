#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-.}"

if [ ! -d "$TARGET" ]; then
  echo "Target is not a directory: $TARGET" >&2
  exit 2
fi

cd "$TARGET"

echo "Vibe Ready local checks"
echo "Target: $(pwd)"
echo

warn() {
  echo "[WARN] $1"
}

pass() {
  echo "[OK] $1"
}

info() {
  echo "[INFO] $1"
}

secret_pattern='sk_live_|pk_live_|AKIA[0-9A-Z]{16}|BEGIN RSA PRIVATE KEY|OPENAI_API_KEY=sk-|ANTHROPIC_API_KEY=sk-'
secret_scan_file="${TMPDIR:-/tmp}/vibe-ready-secret-scan.txt"

has_any() {
  for path in "$@"; do
    if [ -e "$path" ]; then
      return 0
    fi
  done
  return 1
}

if has_any package.json pyproject.toml requirements.txt go.mod Cargo.toml Gemfile composer.json; then
  pass "Dependency manifest found"
else
  warn "No common dependency manifest found"
fi

if has_any .env.example .env.sample .env.template templates/env.example; then
  pass "Environment example found"
else
  warn "No .env.example/.env.sample found"
fi

if [ -f ".env" ]; then
  warn ".env exists in project root. Confirm it is gitignored and contains no committed secrets."
  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if git ls-files --error-unmatch .env >/dev/null 2>&1; then
      warn ".env is tracked by git. Remove it from git history and rotate any exposed secrets."
    else
      pass ".env is not tracked by git"
    fi
  fi
fi

if [ -f ".gitignore" ]; then
  if grep -Eq '(^|/)\.env(\*|$)|\.env\*' .gitignore; then
    pass ".gitignore appears to ignore env files"
  else
    warn ".gitignore does not clearly ignore .env files"
  fi
else
  warn "No .gitignore found"
fi

if find . -maxdepth 4 -type d \( -iname "migrations" -o -iname "prisma" -o -iname "drizzle" -o -iname "supabase" \) | grep -q .; then
  pass "Possible migration/database directory found"
else
  warn "No obvious migration/database directory found"
fi

if find . -maxdepth 4 -type f \( -iname "*test*" -o -iname "*.spec.*" -o -iname "*.test.*" \) | grep -q .; then
  pass "Possible tests found"
else
  warn "No obvious tests found"
fi

if find . -maxdepth 5 \
  \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' \) -prune -o \
  -type f \( -iname "*stripe*" -o -iname "*payment*" -o -iname "*webhook*" \) -print | grep -q .; then
  info "Payment/webhook-related files found. Apply checklists/payment-readiness.md"
else
  info "No obvious payment/webhook files found"
fi

if find . -maxdepth 5 \
  \( -path './.git' -o -path './node_modules' -o -path './checklists' -o -path './prompts' -o -path './templates' \) -prune -o \
  -type f \( -iname "*openai*" -o -iname "*anthropic*" -o -iname "*llm*" -o -iname "*agent*" -o -iname "*mcp*" -o -iname "*fal*" \) -print | grep -q .; then
  info "AI/agent-related files found. Apply checklists/ai-app-readiness.md"
else
  info "No obvious AI/agent files found"
fi

if command -v rg >/dev/null 2>&1; then
  set +e
  rg -n --hidden --glob '!node_modules' --glob '!.git' --glob '!dist' --glob '!build' --glob '!scripts/prodcheck.sh' "$secret_pattern" . >"$secret_scan_file" 2>"${secret_scan_file}.err"
  scan_status=$?
  set -e
  if [ "$scan_status" -eq 0 ]; then
    warn "Possible secret patterns found:"
    sed -n '1,20p' "$secret_scan_file"
  elif [ "$scan_status" -eq 1 ]; then
    pass "No obvious high-signal secret patterns found by lightweight scan"
  else
    warn "Secret scan failed; do not treat this as clean. Error:"
    sed -n '1,10p' "${secret_scan_file}.err"
  fi
else
  warn "ripgrep not installed; using slower grep fallback for lightweight secret scan"
  set +e
  grep -REn --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude=prodcheck.sh "$secret_pattern" . >"$secret_scan_file" 2>"${secret_scan_file}.err"
  scan_status=$?
  set -e
  if [ "$scan_status" -eq 0 ]; then
    warn "Possible secret patterns found:"
    sed -n '1,20p' "$secret_scan_file"
  elif [ "$scan_status" -eq 1 ]; then
    pass "No obvious high-signal secret patterns found by grep fallback"
  else
    warn "Grep secret scan failed; do not treat this as clean. Error:"
    sed -n '1,10p' "${secret_scan_file}.err"
  fi
fi

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  : >"$secret_scan_file.history"
  : >"${secret_scan_file}.history.err"
  set +e
  history_scan_error=0
  for rev in $(git rev-list --all); do
    git grep -n -E "$secret_pattern" "$rev" -- . ':(exclude)scripts/prodcheck.sh' >>"$secret_scan_file.history" 2>>"${secret_scan_file}.history.err"
    git_grep_status=$?
    if [ "$git_grep_status" -gt 1 ]; then
      history_scan_error=1
    fi
  done
  set -e
  if [ "$history_scan_error" -ne 0 ]; then
    warn "Git history secret scan failed; do not treat history as clean. Error:"
    sed -n '1,10p' "${secret_scan_file}.history.err"
  elif [ -s "$secret_scan_file.history" ]; then
    warn "Possible secret patterns found in git history:"
    sed -n '1,20p' "$secret_scan_file.history"
  else
    pass "No obvious high-signal secret patterns found in git history"
  fi
fi

echo
echo "Next: run an agent review with AGENTS.md and the checklists."
