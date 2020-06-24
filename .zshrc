# ヒストリの設定 {{{
 HISTFILE=~/.zsh_history
 HISTSIZE=1000000
 SAVEHIST=1000000
 # }}}

# zstyle {{{
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=2

autoload colors
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# }}}

# setopt {{{
  setopt hist_ignore_dups   # 直前と同じコマンドラインはヒストリに追加しない
  setopt hist_ignore_all_dups  # 重複したヒストリは追加しない
  setopt hist_ignore_space # スペースから始まるコマンド行はヒストリに残さない
  setopt magic_equal_subst
  setopt auto_list  # 補完候補が複数ある時に、一覧表示
  setopt auto_menu  # 補完候補が複数あるときに自動的に一覧表示する
  setopt share_history  # シェルのプロセスごとに履歴を共有
  setopt ignore_eof # Ctrl+Dでzshを終了しない
# }}}

# bindKey {{{
bindkey "^[[3~" delete-char # Deleteを使えるように
# }}}

# zplug {{{
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "mafredri/zsh-async"
zplug "sindresorhus/pure"
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose
# }}}

export PATH="$HOME/.anyenv/bin:$PATH"
export PATH=$HOME/.anyenv/envs/nodenv/versions/12.16.1/bin/:$PATH
eval "$(anyenv init -)"
export PATH="/home/ucpr/.local/bin:$PATH"
export GOPATH="$HOME/Works/.go"
export PATH="/home/ucpr/Works/.go/bin:$PATH"

if [ -f ~/.aliases  ]; then
  . ~/.aliases
fi

# shortcut {{{

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

export LESS='-RNMS'
export LESSOPEN='|lessfilter %s'

# peco
peco_find_cd() {
  cd "$(find . -type d | grep -v "\/\." | peco)"
}
alias pcd="peco_find_cd"

## Ctrl+R
peco_select_history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco_select_history
bindkey '^r' peco_select_history

## branchをpecoで
alias -g bp='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
## docker execをpecoで
alias depc='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

set_proxy() {
  export http_proxy="http://cproxy.okinawa-ct.ac.jp:8080"
  export https_prxoy=$http_proxy
  export ftp_proxy=$http_proxy
  export HTTP_PROXY=$http_proxy
  export HTTPS_PROXY=$http_proxy
  export FTP_PROXY=$http_proxy

#  apm config set https-proxy $http_proxy
#  apm config set https-proxy $http_proxy
  git config --global http.proxy $http_proxy
#  npm config set proxy $http_proxy
#  npm config set https-proxy $http_proxy
  alias sudo="sudo -E"
  if [ -f ~/.curlrc.conf ]; then 
    mv ~/.curlrc.conf ~/.curlrc
  fi
  if [ -f ~/.wgetrc.conf ]; then 
    mv ~/.wgetrc.conf ~/.wgetrc
  fi
#  echo "Proxy environment variable set."
}

unset_proxy() {
  unset http_proxy
  unset https_prxoy
  unset HTTP_PROXY
  unset HTTPS_PROXY

  git config --global --unset http.proxy
#  npm config delete proxy
#  npm config delete https-proxy
#  apm config delete http-proxy
#  apm config delete https-proxy
  if [ -f ~/.curlrc ]; then 
    mv ~/.curlrc ~/.curlrc.conf
  fi
  if [ -f ~/.wgetrc ]; then 
    mv ~/.wgetrc ~/.wgetrc.conf
  fi
#  echo -e "Proxy environment variable removed."
}

function get_ssid() {
    echo `nmcli dev status | grep 'ajima' | awk '{print $4}'`
}

export switch_tori=ajima
echo `get_ssid`

if [ "`get_ssid`" = "$switch_tori" ]; then
#    echo -e "\e[31mSwitch to proxy for school network\e[m"
    set_proxy
else
#    echo -e "\e[36mUnset proxy settings\e[m"
    unset_proxy
fi

# }}}
