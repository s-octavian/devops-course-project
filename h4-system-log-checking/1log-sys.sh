#!/bin/bash

LOG="/var/log/messages"
PATTERN="error|fail|critical|warning|denied|fault|REQUEST|root"
EXCLUDE="gnome-shell|dnf-makecache|makecache|dnf"

FIRST_DATE=$(awk 'NR==1 {gsub(":", "-", $3); print $1"_"$2"_"$3}' "$LOG")
NOW=$(date +%b_%d_%H-%M-%S)

OUTFILE="log_${FIRST_DATE}_to_${NOW}.log"

grep -iE "$PATTERN" "$LOG" \
| grep -ivE "$EXCLUDE" \
| awk '{print $1,$2,$3,$5,$0}' \
> "$OUTFILE"
