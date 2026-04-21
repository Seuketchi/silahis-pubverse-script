#!/bin/bash
# bulk_create_users.sh
# Creates multiple users from a CSV file
# CSV format: username,fullname,password,description
# Usage: sudo bash bulk_create_users.sh users.csv

CSV_FILE=$1

if [ -z "$CSV_FILE" ] || [ ! -f "$CSV_FILE" ]; then
    echo "Usage: sudo bash bulk_create_users.sh <csv_file>"
    exit 1
fi

tail -n +2 "$CSV_FILE" | while IFS=',' read -r USERNAME FULLNAME PASSWORD DESCRIPTION; do
    USERNAME=$(echo "$USERNAME" | xargs)
    FULLNAME=$(echo "$FULLNAME" | xargs)
    PASSWORD=$(echo "$PASSWORD" | xargs)

    if dscl . read /Users/$USERNAME &>/dev/null; then
        echo "SKIP: '$USERNAME' already exists."
        continue
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

    echo "Created: '$USERNAME' ($FULLNAME)"
done

echo "Done."
