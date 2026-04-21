#!/bin/bash
# check_files.sh
# Scans the whole laptop for pre-saved design and exported files that may indicate cheating
# Usage: sudo bash check_files.sh

SCAN_ROOT="/"
EXTENSIONS=(
    # InDesign
    "*.indd" "*.indt"
    # Illustrator
    "*.ai" "*.ait"
    # Photoshop
    "*.psd" "*.psb"
    # Exported outputs
    "*.pdf" "*.eps" "*.svg"
    "*.png" "*.jpg" "*.jpeg"
)

# Folders to skip
EXCLUDES=(
    "/System"
    "/Library"
    "/private"
    "/usr"
    "/bin"
    "/sbin"
    "/cores"
    "/dev"
    "/Applications"
)

echo ""
echo "=== Silahis PubVerse — Pre-Competition File Check ==="
echo "Scanning $SCAN_ROOT for suspicious files..."
echo ""

# Build find exclude args
EXCLUDE_ARGS=()
for dir in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(-path "$dir" -prune -o)
done

# Build find name args
NAME_ARGS=()
for ext in "${EXTENSIONS[@]}"; do
    if [ ${#NAME_ARGS[@]} -gt 0 ]; then
        NAME_ARGS+=(-o)
    fi
    NAME_ARGS+=(-iname "$ext")
done

RESULTS=$(find "$SCAN_ROOT" "${EXCLUDE_ARGS[@]}" \( "${NAME_ARGS[@]}" \) -print 2>/dev/null)

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

echo ""
echo "Scan complete."
