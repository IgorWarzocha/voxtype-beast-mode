#!/bin/bash
# voxtype-beast-mode/scripts/router.sh

# Default to 'general' if mode file doesn't exist
MODE_FILE="/tmp/voxtype_mode"
if [ -f "$MODE_FILE" ]; then
    MODE=$(cat "$MODE_FILE")
else
    MODE="general"
fi

# Reset mode to general after reading (so subsequent normal uses don't get stuck in coding mode)
# echo "general" > "$MODE_FILE" &

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$MODE" in
    coding)
        "$SCRIPT_DIR/cleanup-coding.sh"
        ;;
    business)
        "$SCRIPT_DIR/cleanup-business.sh"
        ;;
    general|*)
        "$SCRIPT_DIR/cleanup-general.sh"
        ;;
esac
