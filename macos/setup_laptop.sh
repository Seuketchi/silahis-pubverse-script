#!/bin/bash
# setup_laptop.sh
# Full pre-competition laptop setup: check users, scan files, create competitor account
# Usage: sudo bash setup_laptop.sh

# Step 0 - Verify running as root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: This script must be run with sudo."
    echo "Usage: sudo bash setup_laptop.sh"
    exit 1
fi

pause_and_ask() {
    local question=$1
    echo ""
    read -rp "$question (yes/no): " answer
    if [[ ! "$answer" =~ ^(yes|y)$ ]]; then
        echo "Stopped. Resolve the issue before continuing."
        exit 0
    fi
}

echo ""
echo "============================================"
echo "  Silahis PubVerse - Laptop Setup Script   "
echo "============================================"

# --------------------------------------------------
# Step 1 - Check existing users
# --------------------------------------------------
echo ""
echo "[ Step 1 of 4 ] Checking existing user accounts..."
echo ""

dscl . list /Users UniqueID | awk '$2 >= 500' | sort -k2 -n | while read -r user uid; do
    realname=$(dscl . -read /Users/"$user" RealName 2>/dev/null | tail -1 | xargs)
    echo "  $user (UID: $uid) - $realname"
done

pause_and_ask "Do the existing users look correct? Continue to file scan?"

# --------------------------------------------------
# Step 2 - Scan for suspicious files
# --------------------------------------------------
echo ""
echo "[ Step 2 of 4 ] Scanning for pre-saved design files..."
echo ""

EXCLUDES=("/System" "/Library" "/private" "/usr" "/bin" "/sbin" "/cores" "/dev" "/Applications")
EXCLUDE_ARGS=()
for dir in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(-path "$dir" -prune -o)
done

NAME_ARGS=()
for ext in "*.indd" "*.indt" "*.ai" "*.ait" "*.psd" "*.psb" "*.pdf" "*.eps" "*.svg" "*.png" "*.jpg" "*.jpeg"; do
    [ ${#NAME_ARGS[@]} -gt 0 ] && NAME_ARGS+=(-o)
    NAME_ARGS+=(-iname "$ext")
done

RESULTS=$(find "/" "${EXCLUDE_ARGS[@]}" \( "${NAME_ARGS[@]}" \) -print 2>/dev/null)
COUNT=$(echo "$RESULTS" | grep -c . 2>/dev/null || echo 0)

if [ -z "$RESULTS" ] || [ "$COUNT" -eq 0 ]; then
    echo "No suspicious files found. Laptop is clean."
else
    echo "FOUND $COUNT suspicious file(s):"
    echo ""
    echo "$RESULTS" | sort | while read -r filepath; do
        size=$(du -sh "$filepath" 2>/dev/null | awk '{print $1}')
        modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$filepath" 2>/dev/null)
        echo "  [$size]  $modified  $filepath"
    done
fi

pause_and_ask "Is the laptop clean and ready? Continue to create competitor account?"

# --------------------------------------------------
# Step 3 - Create competitor account
# --------------------------------------------------
echo ""
echo "[ Step 3 of 4 ] Creating competitor account..."
echo ""

read -rp "Enter username (e.g. competitor1): " USERNAME
read -rp "Enter full label (e.g. Competitor 1): " FULLNAME
PASSWORD="pubverse2026"

if dscl . read /Users/"$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists. Skipping creation."
else
    sysadminctl -addUser "$USERNAME" \
                -fullName "$FULLNAME" \
                -password "$PASSWORD" \
                -home /Users/"$USERNAME" \
                -shell /bin/zsh

    if [ ! -d "/Users/$USERNAME" ]; then
        createhomedir -c -u "$USERNAME" > /dev/null 2>&1
    fi

    echo "User '$USERNAME' created with password: $PASSWORD"
fi

# --------------------------------------------------
# Step 4 - Prompt to verify
# --------------------------------------------------
echo ""
echo "[ Step 4 of 4 ] Verification"
echo ""
echo "Please log out and log in as '$USERNAME' to verify the account works."
echo "Password: $PASSWORD"
echo ""
pause_and_ask "Did the login work? Mark this laptop as done?"

echo ""
echo "Laptop setup complete for '$USERNAME'."
echo "============================================"
