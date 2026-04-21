#!/bin/bash
# remove_user.sh
# Removes a local user account (compatible with macOS Ventura/Sonoma/Sequoia)
# Usage: sudo bash remove_user.sh <username> [--delete-home]

USERNAME=$1
DELETE_HOME=$2

if [ -z "$USERNAME" ]; then
    echo "Usage: sudo bash remove_user.sh <username> [--delete-home]"
    exit 1
fi

if ! dscl . read /Users/"$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' not found."
    exit 0
fi

if [ "$DELETE_HOME" = "--delete-home" ]; then
    sysadminctl -deleteUser "$USERNAME" -secure
    echo "User '$USERNAME' removed with home folder."
else
    sysadminctl -deleteUser "$USERNAME"
    echo "User '$USERNAME' removed."
fi
