# ~/.bash_profile
if [[ -f /usr/bin/msys-2.0.dll ]]; then
  export RUNNING_IN_MSYS2=1
fi
if [[ -n $RUNNING_IN_MSYS2 ]]; then
  # Running in MSYS2
  source "${HOME}/.config/git/git-prompt.sh"
fi

conf_dir="${HOME}/.bash.d"

# source extra config scripts from .bash.d/
for conf in $(ls ${conf_dir}/*.sh); do
	source "${conf}"
done

[ -f $HOME/.bash.d/.fzf.bash ] && source $HOME/.bash.d/.fzf.bash
