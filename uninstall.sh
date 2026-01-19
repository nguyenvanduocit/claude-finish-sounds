#!/bin/bash
set -e

SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
HOOK_COMMAND="\$HOME/.claude/sounds/play-random.sh"

echo "Uninstalling Claude finish sounds..."

if [ -d "$SOUNDS_DIR" ]; then
    rm -rf "$SOUNDS_DIR"
    echo "Removed $SOUNDS_DIR"
else
    echo "Sounds directory not found, skipping."
fi

if [ -f "$SETTINGS_FILE" ]; then
    if ! command -v jq &> /dev/null; then
        echo "Warning: jq not found. Please manually remove the hook from $SETTINGS_FILE"
    else
        if jq -e --arg cmd "$HOOK_COMMAND" '.hooks.Stop[]?.hooks[]? | select(.command == $cmd)' "$SETTINGS_FILE" > /dev/null 2>&1; then
            jq --arg cmd "$HOOK_COMMAND" '
                .hooks.Stop = [.hooks.Stop[] | select(.hooks | all(.command != $cmd))]
            ' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "Hook removed from settings.json"
        else
            echo "Hook not found in settings.json, skipping."
        fi
    fi
else
    echo "Settings file not found, skipping."
fi

echo ""
echo "Done! Claude finish sounds has been uninstalled."
