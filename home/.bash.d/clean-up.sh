#!/bin/bash

# Define the history file
HISTORY_FILE="$HOME/.bash_eternal_history"

# Remove duplicate lines in history file, keeping the latest instance
function remove_duplicates {
  awk '!visited[$0]++' "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
  echo "Duplicates removed from history."
}

# Use fzf to pick and remove specific entries
function pick_and_remove {
  local entry_to_remove=$(tac "$HISTORY_FILE" | fzf --preview="grep -n {} $HISTORY_FILE" --preview-window=up:3)

  if [ -n "$entry_to_remove" ]; then
    grep -Fvx "$entry_to_remove" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" && mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
    echo "Removed: $entry_to_remove"
  else
    echo "No entry selected."
  fi
}

# Main function
function clean_history {
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
