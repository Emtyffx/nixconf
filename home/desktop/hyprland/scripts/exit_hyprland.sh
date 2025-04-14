#!/bin/sh

# Exit Hyprland gracefully by closing all programs first

HYPRCMDS=$(hyprctl -j clients | jq -r '.[] | "dispatch closewindow address:\(.address); "')
hyprctl --batch "$HYPRCMDS" >> /tmp/hypr/hyprexitwithgrace.log 2>&1
hyprctl dispatch exit
