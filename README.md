# Claude Code Finish Sounds

Anime sound effects for Claude Code's finish hook. Random play one of the sounds when Claude completes a task.

## Sounds included

- `ara-ara.mp3` - Classic anime "Ara ara~"
- `nheo-nheo.mp3` - Cute whining sound
- `onichan.mp3` - "Onii-chan!"

## Installation

1. Copy sounds to Claude config:

```bash
mkdir -p ~/.claude/sounds
cp *.mp3 ~/.claude/sounds/
cp play-random.sh ~/.claude/sounds/
chmod +x ~/.claude/sounds/play-random.sh
```

2. Add to `~/.claude/settings.json`:

```json
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
```

## Add more sounds

1. Add `.mp3` files to `~/.claude/sounds/`
2. Edit `play-random.sh` and add to the `FILES` array

## Requirements

- macOS (uses `afplay`)
- Claude Code CLI
