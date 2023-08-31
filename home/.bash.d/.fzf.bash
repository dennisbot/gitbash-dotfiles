if [[ -n $RUNNING_IN_MSYS2 ]]; then
  export FZF_DEFAULT_COMMAND='fd --type f -I --exclude .git'
else
  export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --exclude node_modules'
fi


# Auto-completion
# ---------------
source "$HOME/.fzf/shell/completion.bash" 2> /dev/null
# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"
