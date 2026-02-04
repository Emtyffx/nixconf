#!/bin/bash

buses=(4 5)

if [[ "$1" == "inc" ]]; then
    for bus in "${buses[@]}"; do
        # Use +5 as a single argument and & to run in parallel
        ddcutil --bus "$bus" setvcp 10 + 5 & 
    done
    wait # Wait for both monitors to finish
elif [[ "$1" == "dec" ]]; then
    for bus in "${buses[@]}"; do
        # Use -5 as a single argument and & to run in parallel
        ddcutil --bus "$bus" setvcp 10 - 5 & 
    done
    wait
else
    # Fetching brightness from the first bus in the list
    brightness=$(ddcutil --bus "${buses[0]}" getvcp 10 --terse | awk '{print $4}')
# In your test.sh, change the jq line to:
jq -nc --arg p "$brightness" '{"text": $p, "percentage": ($p|tonumber)}'
fi
