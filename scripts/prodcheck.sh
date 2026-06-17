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
  if rg -n --hidden --glob '!node_modules' --glob '!.git' --glob '!dist' --glob '!build' --glob '!scripts/prodcheck.sh' 'sk_live_|pk_live_|AKIA[0-9A-Z]{16}|BEGIN RSA PRIVATE KEY|OPENAI_API_KEY=sk-|ANTHROPIC_API_KEY=sk-' . >/tmp/vibe-ready-secret-scan.txt 2>/dev/null; then
    warn "Possible secret patterns found:"
    sed -n '1,20p' /tmp/vibe-ready-secret-scan.txt
  else
    pass "No obvious high-signal secret patterns found by lightweight scan"
  fi
else
  warn "ripgrep not installed; skipped lightweight secret scan"
fi

echo
echo "Next: run an agent review with AGENTS.md and the checklists."
