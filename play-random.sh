#!/bin/bash
SOUNDS_DIR="$HOME/.claude/sounds"
FILES=("$SOUNDS_DIR"/ara-ara.mp3 "$SOUNDS_DIR"/nheo-nheo.mp3 "$SOUNDS_DIR"/onichan.mp3)
RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"
afplay "$RANDOM_FILE"
