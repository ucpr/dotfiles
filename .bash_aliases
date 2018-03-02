[ `uname` = "Linux" ] && alias open='xdg-open 2>/dev/null'

alias nr="nim c --run"
alias ssh_start="systemctl start sshd"
alias python="python3"
alias pbcopy='xsel --clipboard --input'
alias g++11='g++-6 -std=c++11 -O2 -Wall'
alias g++14='g++-6 -std=c++14 -O2 -Wall'
alias la="ls -a"
alias ll="ls -l"
#alias vim="nvim"
alias py-reqirements='pip freeze > requirements.txt'

ggl() {
    open "https://www.google.co.jp/search?q=${*// /%20}"
}
