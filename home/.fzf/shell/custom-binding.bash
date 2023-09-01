bind -x '"\C-s": "fzf_pickexec"'
fzf_pickexec() {
    local file=$(find . -type f -name "*.exe" | fzf --reverse)
    if [ -n "$file" ]; then
        READLINE_LINE="$file"
        READLINE_POINT=${#READLINE_LINE}
    fi
}

