#!/bin/bash
SOUNDS_DIR="$HOME/.claude/sounds"
FILES=("$SOUNDS_DIR"/*.mp3)
RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"
afplay "$RANDOM_FILE"
