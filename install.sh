#!/bin/bash
set -e

REPO="nguyenvanduocit/claude-finish-sounds"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
SOUNDS_DIR="$HOME/.claude/sounds"
SETTINGS_FILE="$HOME/.claude/settings.json"

echo "Installing Claude finish sounds..."

mkdir -p "$SOUNDS_DIR"

echo "Downloading sounds..."
curl -fsSL "$BASE_URL/sounds/ara-ara.mp3" -o "$SOUNDS_DIR/ara-ara.mp3"
curl -fsSL "$BASE_URL/sounds/nheo-nheo.mp3" -o "$SOUNDS_DIR/nheo-nheo.mp3"
curl -fsSL "$BASE_URL/sounds/onichan.mp3" -o "$SOUNDS_DIR/onichan.mp3"
curl -fsSL "$BASE_URL/sounds/play-random.sh" -o "$SOUNDS_DIR/play-random.sh"
chmod +x "$SOUNDS_DIR/play-random.sh"

echo "Configuring Claude hooks..."
if [ -f "$SETTINGS_FILE" ]; then
    if command -v jq &> /dev/null; then
        HOOK_CONFIG='{"matcher":"","hooks":[{"type":"command","command":"$HOME/.claude/sounds/play-random.sh"}]}'

        if jq -e '.hooks.Stop' "$SETTINGS_FILE" > /dev/null 2>&1; then
            EXISTING=$(jq -c '.hooks.Stop' "$SETTINGS_FILE")
            if echo "$EXISTING" | grep -q "play-random.sh"; then
                echo "Hook already configured."
            else
                jq --argjson hook "$HOOK_CONFIG" '.hooks.Stop += [$hook]' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
                mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
                echo "Hook added to existing Stop hooks."
            fi
        else
            jq --argjson hook "$HOOK_CONFIG" '.hooks.Stop = [$hook]' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp"
            mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "Stop hook created."
        fi
    else
        echo ""
        echo "jq not found. Please manually add to $SETTINGS_FILE:"
        echo '{"hooks":{"Stop":[{"matcher":"","hooks":[{"type":"command","command":"$HOME/.claude/sounds/play-random.sh"}]}]}}'
    fi
else
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/sounds/play-random.sh"
          }
        ]
      }
    ]
  }
}
EOF
    echo "Created settings.json with hook."
fi

echo ""
echo "Done! Claude will now play anime sounds when finishing tasks."
