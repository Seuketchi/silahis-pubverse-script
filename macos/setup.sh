#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

header() { echo -e "\n${CYAN}=== $* ===${NC}"; }
ok()     { echo -e "${GREEN}✔ $*${NC}"; }
warn()   { echo -e "${YELLOW}⚠ $*${NC}"; }
die()    { echo -e "${RED}✖ $*${NC}"; exit 1; }

[[ $EUID -ne 0 ]] && die "Run this script with sudo: sudo bash setup.sh"

# ── Step 1: Existing users ────────────────────────────────────────────────────
header "Step 1 — Existing users"
bash "$SCRIPT_DIR/check_users.sh"

# ── Step 2: Pre-saved file scan ───────────────────────────────────────────────
header "Step 2 — Scanning for pre-saved design/exported files"
SCAN_OUTPUT=$(bash "$SCRIPT_DIR/check_files.sh" 2>&1)
echo "$SCAN_OUTPUT"

handle_files_found() {
    # TODO: implement what happens when suspicious files are found
    # Suggested approaches to consider:
    #   a) Hard-stop — print location, require manual deletion, then re-run
    #   b) Soft-warn — show files, ask "Continue anyway? [y/N]"
    #   c) Auto-delete — rm the found files after confirmation prompt
    #
    # This matters for competition integrity: a hard-stop ensures no files slip
    # through, but soft-warn gives the proctor flexibility for legitimate files.
    :
}

if echo "$SCAN_OUTPUT" | grep -qiE '\.(indd|indt|ai|ait|psd|psb|pdf|eps|svg|png|jpg|jpeg)'; then
    warn "Suspicious files detected."
    handle_files_found
fi
ok "File scan complete."

# ── Step 3: Create competitor account ────────────────────────────────────────
header "Step 3 — Create competitor account"

read -rp "Username (e.g. competitor1): " USERNAME
[[ -z "$USERNAME" ]] && die "Username cannot be empty."

read -rp "Full name (e.g. Competitor 1): " FULLNAME
[[ -z "$FULLNAME" ]] && die "Full name cannot be empty."

read -rsp "Password: " PASSWORD; echo
[[ -z "$PASSWORD" ]] && die "Password cannot be empty."

bash "$SCRIPT_DIR/create_user.sh" "$USERNAME" "$FULLNAME" "$PASSWORD"
ok "Account '$USERNAME' created."

# ── Step 4: Reminder ─────────────────────────────────────────────────────────
echo -e "\n${GREEN}Setup complete.${NC}"
echo "→ Log out and verify the account works before moving to the next laptop."
echo "→ Remember: sudo bash remove_user.sh $USERNAME --delete-home  after the competition."
