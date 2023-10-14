bind -x '"\e\C-s": "mkrecent"'
bind -x '"\C-s": "fzf_pickexec"'
fzf_pickexec() {
    local files=($(ls --color=never -t *.exe | head -n 2))
    local file

    if [[ ${#files[@]} -gt 0 ]]; then
        if [[ ${#files[@]} -gt 1 ]]; then
            file=$(printf '%s\n' "${files[0]} < input" "${files[0]}" "${files[1]}" | fzf --height ~60 --reverse)
        else
            file=$(printf '%s\n' "${files[0]} < input" "${files[0]}" | fzf --height ~60 --reverse)
        fi

        if [[ "$file" == "${files[0]} < input" ]]; then
            READLINE_LINE="./${files[0]} < input"
        else
            READLINE_LINE="./$file"
        fi

        READLINE_POINT=${#READLINE_LINE}
    fi
}

