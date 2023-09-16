bind -x '"\C-s": "fzf_pickexec"'
fzf_pickexec() {
    local file=$(ls --color=never -t *.exe | fzf --height ~60 --reverse)
    if [ -n "$file" ]; then
        READLINE_LINE="./$file < input"
        READLINE_POINT=${#READLINE_LINE}
    fi
}

