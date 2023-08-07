export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --exclude node_modules'

# Auto-completion
# ---------------
source "$HOME/.fzf/shell/completion.bash" 2> /dev/null
# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.bash"
