#!/bin/bash
# remove_user.sh
# Removes a local user account and optionally deletes their home folder
# Usage: sudo bash remove_user.sh <username> [--delete-home]

USERNAME=$1
DELETE_HOME=$2

if [ -z "$USERNAME" ]; then
    echo "Usage: sudo bash remove_user.sh <username> [--delete-home]"
    exit 1
fi

if ! dscl . read /Users/$USERNAME &>/dev/null; then
    echo "User '$USERNAME' not found."
    exit 0
fi

dscl . delete /Users/$USERNAME

if [ "$DELETE_HOME" = "--delete-home" ]; then
    rm -rf /Users/$USERNAME
    echo "Home folder deleted: /Users/$USERNAME"
fi

echo "User '$USERNAME' removed."
