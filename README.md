# Claude Code Finish Sounds

Anime sound effects for Claude Code's finish hook. Plays a random sound when Claude completes a task.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/nguyenvanduocit/claude-finish-sounds/main/install.sh | bash
```

Requires `jq`. Install with `brew install jq` if needed.

## Desktop Notifications (Optional)

Install `terminal-notifier` to get notifications with click-to-focus:

```bash
brew install terminal-notifier
```

Supported terminals:

- Terminal.app
- iTerm2
- Warp
- Ghostty
- Alacritty
- Kitty
- VS Code

Click the notification to bring your terminal to focus.

## Sounds Included

- `ara-ara.mp3` - Classic anime "Ara ara~"
- `nheo-nheo.mp3` - Cute whining sound
- `onichan.mp3` - "Onii-chan!"

## Add More Sounds

Drop any `.mp3` files into `~/.claude/sounds/` - they'll be picked up automatically.

## Requirements

- macOS (uses `afplay`)
- Claude Code CLI
- `jq` (for installation)
- `terminal-notifier` (optional, for notifications)
