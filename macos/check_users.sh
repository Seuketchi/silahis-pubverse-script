#!/bin/bash
# check_users.sh
# Lists all non-system local user accounts and their status
# Usage: bash check_users.sh

echo "=== Local User Accounts ==="
echo ""

# Show standard users (UID >= 500) via dscl — works on all macOS versions
dscl . list /Users UniqueID | awk '$2 >= 500' | sort -k2 -n | while read -r user uid; do
    realname=$(dscl . -read /Users/"$user" RealName 2>/dev/null | tail -1 | xargs)
    home=$(dscl . -read /Users/"$user" NFSHomeDirectory 2>/dev/null | awk '{print $2}')
    echo "  User:     $user"
    echo "  UID:      $uid"
    echo "  Name:     $realname"
    echo "  Home:     $home"
    echo ""
done

# Also show via sysadminctl for a quick overview (macOS Ventura+)
echo "=== sysadminctl Overview ==="
sysadminctl -listUsers 2>/dev/null || echo "(sysadminctl not available on this version)"
