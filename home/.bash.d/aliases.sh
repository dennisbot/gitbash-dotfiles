# Bash aliases

# Shortcuts for often used commands, a.o. based on top commands in Bash
# history (see functions.sh, topcmd function)
# Credit https://coderwall.com/p/o5qijw

alias cls='clear'
alias his='history | tail -20'
alias fzgrep='history|cut -c 8-|sort|uniq|grep --color'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=/Users/dennisbot/.dotfiles/ --work-tree=/Users/dennisbot'
alias cpwd='pwd | clip'
alias gr='cd "$(git rev-parse --show-toplevel)"'
alias os='subl "$(git rev-parse --show-toplevel)"'
alias getremoteb="cls && git branch -r | grep -v '\->' | xargs -p -I % bash -c 'git branch --track ${0#origin/} $0' %"
alias ss='start wt -d $PWD'
# alias ssm='start wt new-tab -p "{2e1f7332-f218-4e15-9abe-df88b7f3e6ef}"'
alias ssm='start wt new-tab -p "{2e1f7332-f218-4e15-9abe-df88b7f3e6ef}" -d "$(cygpath -w "$PWD")"'

# Git
alias ga='git add'
# alias dd='gh dev..' we have a function that does more things in shell.sh
alias gb='git branch'
alias gcb='git branch | fzf --height ~60 --reverse | xargs -I {} git checkout {}'
alias gbd='git branch | fzf --height ~60 --reverse | xargs -I {} git branch -D {}'
alias mk='make -f ~/Makefile FILE=$(ls --color=never -t *.cpp | fzf --height ~60 --reverse --select-1)'
alias mkrecent='make -f ~/Makefile FILE=$(ls --color=never -t *.cpp | head -n 1)'
alias mkc='make -f ~/Makefile clean'
alias gc='git commit --no-verify -m'
alias gd='git diff'
alias gh='git hist'
alias gl='git lg'
alias gll='git log --pretty="format:%C(yellow)%h %C(blue)%ad %C(reset)%s%C(red)%d %C(green)%an%C(reset), %C(cyan)%ar" --date=short --graph --all'
alias push='git push'
alias pull='git pull'
alias gpt='git push && git push --tags'
alias gs='git status'
# Git author stats
alias gas='git ls-tree -r -z --name-only HEAD | xargs -0 -n1 git blame --line-porcelain | grep  "^author "|sort|uniq -c|sort -nr'

# Vagrant
alias v='vagrant'
alias vD='vagrant destroy --force'
alias vd='vagrant destroy'
alias vdu='vagrant destroy --force && vagrant up'
alias vh='vagrant halt'
alias vp='vagrant provision'
alias vr='vagrant reload'
alias vS='vagrant ssh'
alias vs='vagrant status'
alias vu='vagrant up'

#entity framework

alias mm='cd "$(git rev-parse --show-toplevel)/EMS.Migrations"'
alias cc='cd "$(git rev-parse --show-toplevel)/src/Client"'

# Directory listing and file system
# Use rational units/formats in file size & date output
alias df='df --si'
alias du='du --total --si'
alias l='ls -l --si --time-style=long-iso --color'
alias ls='ls -h --si --time-style=long-iso --color'
alias la='ls -la --si --time-style=long-iso --color'
alias ll='ls -l  --si --time-style=long-iso --color'
alias lh='ls -lh  --si --time-style=long-iso --color'
alias tree='tree -AC'

# Protect root against shooting himself in the foot
if [ "$(id -ru)" -eq "0" ]; then
  alias rm='rm --interactive=once'
  alias cp='cp --interactive=once'
  alias mv='mv --interactive=once'
else
  alias cp='cp -r'
fi

# Find stuff
alias ff='find . -type f -name '
# alias fd='find . -type d -name '
alias formatcs='/c/provistacorp/repos/format-cs-files.sh'
