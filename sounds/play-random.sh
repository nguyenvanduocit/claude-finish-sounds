#!/bin/bash
SOUNDS_DIR="$HOME/.claude/sounds"
FILES=("$SOUNDS_DIR"/*.mp3)

if [ ${#FILES[@]} -eq 0 ] || [ ! -f "${FILES[0]}" ]; then
    exit 0
fi

RANDOM_FILE="${FILES[$RANDOM % ${#FILES[@]}]}"
afplay "$RANDOM_FILE" &

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

    NOTIFY_ARGS=(
        -title "Claude"
        -message "Task completed!"
        -sound ""
    )

    if [ -n "$BUNDLE_ID" ]; then
        NOTIFY_ARGS+=(-activate "$BUNDLE_ID")
    fi

    terminal-notifier "${NOTIFY_ARGS[@]}" &> /dev/null &
fi
