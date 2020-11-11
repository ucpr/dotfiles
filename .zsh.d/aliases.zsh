[ `uname` = "Linux" ] && alias open='xdg-open 2>/dev/null'

alias pbcopy='xsel --clipboard --input'

alias g++11='g++-6 -std=c++11 -O2 -Wall'
alias g++14='g++-6 -std=c++14 -O2 -Wall'

alias ls='ls --color=auto'
alias la="ls -a"
alias ll="ls -l"
alias sl='ls'

alias python="python3"
alias py="python3"
alias py-reqirements='pip freeze > requirements.txt'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias pdf-apvlv='apvlv'

alias apv=/usr/lib/jvm/java-8-openjdk/bin/appletviewer

## branchをpecoで
alias -g bp='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
## docker execをpecoで
alias depc='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

peco_find_cd() {
  cd "$(find . -type d | grep -v "\/\." | peco)"
}
alias pcd="peco_find_cd"

peco_select_history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

ggl() {
    open "https://google.com/search?q=${*// /%20}"
}
