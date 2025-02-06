#!/bin/bash

# Define the history file
HISTORY_FILE="$HOME/.bash_eternal_history"

# Move most used commands to the end of the file, prioritizing shorter commands
function prioritize_frequent_commands {
  # Count frequency of each command and calculate string length
  awk '
    { count[$0]++; len[$0] = length($0) } 
    END { for (cmd in count) print count[cmd], len[cmd], cmd }
  ' "$HISTORY_FILE" |
    sort -n -k1,1 -k2,2r | # Sort by frequency (ascending) and then by length (descending)
    # sort -n -k1,2 |                    # Sort by frequency (ascending) and then by length (ascending)
    awk '{ $1=""; $2=""; print $0 }' | # Remove the frequency and length fields
    sed 's/^ *//' >"$HISTORY_FILE.tmp" # Clean up leading spaces

  mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
  echo "Most used commands (with shorter commands last) moved to the end of the history file."
}

# Remove duplicate lines in history file, keeping the latest instance
function remove_duplicates {
  tac "$HISTORY_FILE" | awk '!visited[$0]++' | tac >"$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
  echo "Duplicates removed from history."
}

# Use fzf to pick and remove specific entries
function pick_and_remove {
  local entry_to_remove=$(tac "$HISTORY_FILE" | fzf --preview="grep -n {} $HISTORY_FILE" --preview-window=up:3)

  if [ -n "$entry_to_remove" ]; then
    grep -Fvx "$entry_to_remove" "$HISTORY_FILE" >"$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    echo "Removed: $entry_to_remove"
  else
    echo "No entry selected."
  fi
}

# Main function
function clean_history {
  prioritize_frequent_commands
  remove_duplicates
  while true; do
    pick_and_remove
    echo "Do you want to remove another entry? (y/n)"
    read -r answer
    [[ $answer != "y" ]] && break
  done
}

# Alias to trigger the cleanup
alias clean_hist='clean_history'
