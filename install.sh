#!/bin/bash
set -e

REPO="nguyenvanduocit/claude-finish-sounds"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"
HOOK_COMMAND="\$HOME/.claude/sounds/play-random.sh"

FORCE=false
[ "$1" = "--force" ] && FORCE=true

check_installed() {
    if [ -f "$SOUNDS_DIR/play-random.sh" ] && [ -f "$SETTINGS_FILE" ]; then
        if jq -e --arg cmd "$HOOK_COMMAND" '.hooks.Stop[]?.hooks[]? | select(.command == $cmd)' "$SETTINGS_FILE" > /dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required. Install with: brew install jq"
    exit 1
fi

if [ "$FORCE" = false ] && check_installed; then
    echo "Claude finish sounds is already installed."
    echo ""
    echo "To reinstall: curl -fsSL $BASE_URL/install.sh | bash -s -- --force"
    echo "To uninstall: curl -fsSL $BASE_URL/uninstall.sh | bash"
    exit 0
fi

if [ "$FORCE" = true ]; then
    echo "Reinstalling Claude finish sounds..."
else
    echo "Installing Claude finish sounds..."
fi

mkdir -p "$SOUNDS_DIR"

echo "Downloading sounds..."
curl -fsSL "$BASE_URL/sounds/ara-ara.mp3" -o "$SOUNDS_DIR/ara-ara.mp3"
curl -fsSL "$BASE_URL/sounds/nheo-nheo.mp3" -o "$SOUNDS_DIR/nheo-nheo.mp3"
curl -fsSL "$BASE_URL/sounds/onichan.mp3" -o "$SOUNDS_DIR/onichan.mp3"
curl -fsSL "$BASE_URL/sounds/play-random.sh" -o "$SOUNDS_DIR/play-random.sh"
chmod +x "$SOUNDS_DIR/play-random.sh"

echo "Configuring Claude hooks..."

mkdir -p "$(dirname "$SETTINGS_FILE")"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
fi

if ! jq empty "$SETTINGS_FILE" 2>/dev/null; then
    echo "Error: $SETTINGS_FILE is not valid JSON"
    exit 1
fi

if jq -e --arg cmd "$HOOK_COMMAND" '.hooks.Stop[]?.hooks[]? | select(.command == $cmd)' "$SETTINGS_FILE" > /dev/null 2>&1; then
    echo "Hook already configured."
else
    jq --arg cmd "$HOOK_COMMAND" '
        .hooks //= {} |
        .hooks.Stop //= [] |
        .hooks.Stop += [{"matcher": "", "hooks": [{"type": "command", "command": $cmd}]}]
    ' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    echo "Hook added."
fi

echo ""
echo "Done! Claude will now play anime sounds when finishing tasks."

if ! command -v terminal-notifier &> /dev/null; then
    echo ""
    echo "Optional: Install terminal-notifier for desktop notifications:"
    echo "  brew install terminal-notifier"
fi
