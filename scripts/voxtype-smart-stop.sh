#!/bin/bash
# ~/.config/hypr/scripts/voxtype-smart-stop.sh
#
# Robust stop script that handles sloppy releases and blocks modifiers during typing.

STATE_FILE="$XDG_RUNTIME_DIR/voxtype/state"

# 1. Exit if not recording
if [[ ! -f "$STATE_FILE" ]] || [[ $(cat "$STATE_FILE") != "recording" ]]; then
    exit 0
fi

# 2. Enter suppression submap to block modifiers (Super/Ctrl/Alt) while typing
hyprctl dispatch submap voxtype_suppress

# 3. Trigger the stop signal
voxtype record stop

# 4. Wait for Voxtype to return to idle (finished transcribing and typing)
for i in {1..300}; do
    if [[ $(cat "$STATE_FILE" 2>/dev/null) == "idle" ]]; then
        break
    fi
    sleep 0.05
done

# 5. Safety buffer (adjust to preference)
sleep 2.0

# 6. Restore normal keyboard behavior
hyprctl dispatch submap reset
