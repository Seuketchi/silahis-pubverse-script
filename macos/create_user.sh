#!/bin/bash
# create_user.sh
# Creates a new standard local user account
# Usage: sudo bash create_user.sh <username> "Full Name" <password>

USERNAME=$1
FULLNAME=$2
PASSWORD=$3

if [ -z "$USERNAME" ] || [ -z "$FULLNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: sudo bash create_user.sh <username> \"Full Name\" <password>"
    exit 1
fi

if dscl . read /Users/$USERNAME &>/dev/null; then
    echo "User '$USERNAME' already exists."
    exit 1
fi

LAST_UID=$(dscl . list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NEW_UID=$((LAST_UID + 1))

dscl . create /Users/$USERNAME
dscl . create /Users/$USERNAME RealName "$FULLNAME"
dscl . create /Users/$USERNAME UniqueID $NEW_UID
dscl . create /Users/$USERNAME PrimaryGroupID 20
dscl . create /Users/$USERNAME UserShell /bin/bash
dscl . create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
dscl . passwd /Users/$USERNAME "$PASSWORD"

createhomedir -c -u $USERNAME > /dev/null 2>&1

echo "User '$USERNAME' ($FULLNAME) created successfully (UID: $NEW_UID)."
