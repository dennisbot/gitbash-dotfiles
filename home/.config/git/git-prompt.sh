PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\n'                 # new line
TIME='\[\033[01;31m\]\t \[\033[01;32m\]'
USER='\u ';
# HOST='\033[02;36m\]\h \033[01;34m\]'
HOST='\[\033[02;36m\]\h \[\033[01;34m\]'

PS1="$TIME"
PS1="$PS1$USER"
PS1="$PS1$HOST"
PS1="$PS1"'\w \[\033[00;33m\]'                 # current working directory
if test -z "$WINELOADERNOEXEC"
then
  GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
  COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
  COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
  COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
  if test -f "$COMPLETION_PATH/git-prompt.sh"
  then
    . "$COMPLETION_PATH/git-completion.bash"
    . "$COMPLETION_PATH/git-prompt.sh"
    PS1="$PS1"'\[\033[36m\]'  # change color to cyan
    PS1="$PS1"'`__git_ps1 [%s]`'   # bash function
  fi
fi
PS1="$PS1"'\[\033[0m\]'        # change color
# PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $
