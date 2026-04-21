#!/bin/bash
# create_user.sh
# Creates a new standard local user account (compatible with macOS Ventura/Sonoma/Sequoia)
# Usage: sudo bash create_user.sh <username> "Full Name" <password>

USERNAME=$1
FULLNAME=$2
PASSWORD=$3

if [ -z "$USERNAME" ] || [ -z "$FULLNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: sudo bash create_user.sh <username> \"Full Name\" <password>"
    exit 1
fi

if dscl . read /Users/"$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists."
    exit 1
fi

sysadminctl -addUser "$USERNAME" \
            -fullName "$FULLNAME" \
            -password "$PASSWORD" \
            -home /Users/"$USERNAME" \
            -shell /bin/zsh

# Create home directory if sysadminctl didn't make one
if [ ! -d "/Users/$USERNAME" ]; then
    createhomedir -c -u "$USERNAME" > /dev/null 2>&1
fi

echo "User '$USERNAME' ($FULLNAME) created successfully."
