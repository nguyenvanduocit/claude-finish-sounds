#!/bin/bash
SOUNDS_DIR="$HOME/.claude/sounds"
FILES=("$SOUNDS_DIR"/*.mp3)

if [ ${#FILES[@]} -eq 0 ] || [ ! -f "${FILES[0]}" ]; then
    exit 0
fi

RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"
afplay "$RANDOM_FILE" &
