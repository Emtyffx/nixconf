#!/usr/bin/env bash

AUTOSTART_FILE="$HOME/.autostart-hyprland"

if [ ! -f "$AUTOSTART_FILE" ]; then
  touch "$AUTOSTART_FILE"
fi

echo "3"

while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    continue
  fi
  echo "$line"

  sh -c "$line" &

done < "$AUTOSTART_FILE"


