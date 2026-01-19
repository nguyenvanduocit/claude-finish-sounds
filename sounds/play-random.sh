#!/bin/bash
SOUNDS_DIR="$HOME/.claude/sounds"
FILES=("$SOUNDS_DIR"/*.mp3)

if [ ${#FILES[@]} -eq 0 ] || [ ! -f "${FILES[0]}" ]; then
    exit 0
fi

RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"
afplay "$RANDOM_FILE" &

INPUT=$(cat)

PROJECT_NAME=""
SESSION_TITLE=""

if command -v jq &> /dev/null && [ -n "$INPUT" ]; then
    CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
    TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

    if [ -n "$CWD" ]; then
        PROJECT_NAME=$(basename "$CWD")
    fi

    if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
        FIRST_MSG=$(grep -m1 '"type":"user"' "$TRANSCRIPT" 2>/dev/null | jq -r '.content // empty' 2>/dev/null | head -c 50)
        if [ -n "$FIRST_MSG" ]; then
            SESSION_TITLE="$FIRST_MSG"
            [ ${#FIRST_MSG} -ge 50 ] && SESSION_TITLE="${SESSION_TITLE}..."
        fi
    fi
fi

get_terminal_bundle_id() {
    case "$TERM_PROGRAM" in
        "Apple_Terminal") echo "com.apple.Terminal" ;;
        "iTerm.app") echo "com.googlecode.iterm2" ;;
        "WarpTerminal") echo "dev.warp.Warp-Stable" ;;
        "ghostty") echo "com.mitchellh.ghostty" ;;
        "Alacritty") echo "org.alacritty" ;;
        "kitty") echo "net.kovidgoyal.kitty" ;;
        "vscode") echo "com.microsoft.VSCode" ;;
        *) echo "" ;;
    esac
}

if command -v terminal-notifier &> /dev/null; then
    BUNDLE_ID=$(get_terminal_bundle_id)

    if [ -n "$PROJECT_NAME" ]; then
        TITLE="Claude · $PROJECT_NAME"
    else
        TITLE="Claude"
    fi

    if [ -n "$SESSION_TITLE" ]; then
        MESSAGE="$SESSION_TITLE"
    else
        MESSAGE="Task completed!"
    fi

    NOTIFY_ARGS=(
        -title "$TITLE"
        -message "$MESSAGE"
        -sound ""
    )

    if [ -n "$BUNDLE_ID" ]; then
        NOTIFY_ARGS+=(-activate "$BUNDLE_ID")
    fi

    terminal-notifier "${NOTIFY_ARGS[@]}" &> /dev/null &
fi
