#!/bin/bash
# Usage: workspace-switch.sh <key> [move]
# key = 1-10 (maps to 0 key as 10)
# move = optional, moves focused window instead of just switching

KEY=$1
ACTION=${2:-"workspace"}

# Map key 0 -> 10
if [ "$KEY" = "0" ]; then
  KEY=10
fi

# Get the focused monitor name
FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$FOCUSED_MONITOR" = "eDP-1" ]; then
  TARGET=$KEY # 1-10
else
  TARGET=$((KEY + 10)) # 11-20
fi

if [ "$ACTION" = "move" ]; then
  hyprctl dispatch movetoworkspace "$TARGET"
else
  hyprctl dispatch workspace "$TARGET"
fi
