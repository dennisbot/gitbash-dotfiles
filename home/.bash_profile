# Set user-defined locale
export LANG=$(locale -uU)

# ~/.bash_profile;
if [ ! -f "$HOME/NTUSER.DAT" ]; then
  export RUNNING_IN_MSYS2=1
fi
if [[ -n $RUNNING_IN_MSYS2 ]]; then
  export PATH="$PATH:/c/ProgramData/chocolatey/bin:/c/Program Files/Sublime Text:/c/Program Files/Git/bin:/c/Program Files/Microsoft VS Code/bin"
  # Running in MSYS2
  source "${HOME}/.config/git/git-prompt.sh"
fi

conf_dir="${HOME}/.bash.d"

# source extra config scripts from .bash.d/
for conf in $(ls ${conf_dir}/*.sh); do
	source "${conf}"
done

eval "$(fnm env --use-on-cd --shell bash)"
