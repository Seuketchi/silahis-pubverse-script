#!/bin/bash
# check_users.sh
# Lists all non-system local user accounts
# Usage: bash check_users.sh

echo "=== Local User Accounts ==="

dscl . list /Users | grep -v '^_' | while read user; do
    uid=$(dscl . -read /Users/$user UniqueID 2>/dev/null | awk '{print $2}')
    if [ -n "$uid" ] && [ "$uid" -ge 500 ] 2>/dev/null; then
        realname=$(dscl . -read /Users/$user RealName 2>/dev/null | tail -1 | xargs)
        echo "  $user (UID: $uid) — $realname"
    fi
done
