# ! /bin/bash

# Bash Shell Configuration

# Sources:
# - http://codeinthehole.com/writing/the-most-important-command-line-tip-
#     incremental-history-searching-with-inputrc/
# - https://github.com/mrzool/bash-sensible/blob/master/sensible.bash

# ---------- General settings -------------------------------------------------

# Make vim the default editor
# export EDITOR="vim"
# Make sublime the default editor

export EDITOR="sublime -n -w"

# After each command, append to the history file and reread it
# TODO
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

shopt -s checkwinsize # update window size after each command

# Prevent file overwrite with >. Use >| to force
set -o noclobber

# Disable Ctrl-S keyboard shortcut for ScrollLock (locks up Vim)
# Source: https://unix.stackexchange.com/questions/72086/ctrl-s-hang-terminal-emulator
stty -ixon

# ---------- History ----------------------------------------------------------

# Larger bash history (allow more entries; default is 500)
export HISTSIZE=500000
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups:ignorespace
export HISTFILE="$HOME/.bash_eternal_history"
# Make some commands not show up in history
export HISTIGNORE="&:ls:cd:cd -:pwd:exit:bg:fg"
# export HISTTIMEFORMAT='%F %T '

shopt -s histappend   # append to history, don't overwrite
shopt -s cmdhist      # enter multi-line commands as one entry

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here:
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'


#---------- Completion --------------------------------------------------------

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"


# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

#---------- Directory navigation ----------------------------------------------

shopt -s autocd       # entering a directory as command will cd into it
shopt -s cdspell      # autocorrect typos in path names when using 'cd'
shopt -s globstar     # allow use of ** in file globbing
shopt -s nocaseglob   # case insensitive globbing

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
# CDPATH=".:~:~/CfgMgmt"

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars
export hogent="${HOME}/OneDrive - Hogeschool Gent"

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# export PROMPT_COMMAND='history -a;history -c;history -r;$PROMPT_COMMAND'
dd() {
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" == "dev" ] || [ "$current_branch" == "develop" ] || [ "$current_branch" == "master" ] || [ "$current_branch" == "main" ]; then
        gh -5
    else
        gh develop..
    fi
}
