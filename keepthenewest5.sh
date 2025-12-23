#!/bin/bash

# Usage: keepthenewest5.sh <LOGDIR> <DEST> <FILENAME_PATTERN>
# Example: keepthenewest5.sh /var/log /tmp "FILE*.log"

LOGDIR="$1"
DEST="$2"
PATTERN="$3"

# Validate input
if [[ -z "$LOGDIR" || -z "$DEST" || -z "$PATTERN" ]]; then
    echo "Usage: $0 <LOGDIR> <DEST> <FILENAME_PATTERN>"
    echo "Example: $0 /var/log /tmp \"FILE*.log\""
    exit 1
fi

# Ensure directories exist
if [[ ! -d "$LOGDIR" ]]; then
    echo "Error: LOGDIR does not exist: $LOGDIR"
    exit 1
fi

if [[ ! -d "$DEST" ]]; then
    echo "Error: DEST does not exist: $DEST"
    exit 1
fi

cd "$LOGDIR" || exit 1

# Find matching files sorted by newest first
mapfile -t files < <(
    find . -maxdepth 1 -type f -name "$PATTERN" -printf "%T@ %p\n" \
    | sort -nr | awk '{print $2}'
)

# If 5 or fewer files, nothing to move
if (( ${#files[@]} <= 5 )); then
    echo "Nothing to move — 5 or fewer files match '$PATTERN'."
    exit 0
fi

# Move all files except the newest 5
for ((i=5; i<${#files[@]}; i++)); do
    file="${files[$i]}"
    echo "Moving $LOGDIR/$file → $DEST"
    mv "$file" "$DEST"/
done

echo "Done."
