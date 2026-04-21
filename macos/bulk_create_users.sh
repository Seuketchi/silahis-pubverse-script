#!/bin/bash
# bulk_create_users.sh
# Creates multiple users from a CSV file (compatible with macOS Ventura/Sonoma/Sequoia)
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

    if dscl . read /Users/"$USERNAME" &>/dev/null; then
        echo "SKIP: '$USERNAME' already exists."
        continue
    fi

    sysadminctl -addUser "$USERNAME" \
                -fullName "$FULLNAME" \
                -password "$PASSWORD" \
                -home /Users/"$USERNAME" \
                -shell /bin/zsh

    if [ ! -d "/Users/$USERNAME" ]; then
        createhomedir -c -u "$USERNAME" > /dev/null 2>&1
    fi

    echo "Created: '$USERNAME' ($FULLNAME)"
done

echo "Done."
