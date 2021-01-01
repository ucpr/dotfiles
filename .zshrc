# zsh configuration {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

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

setopt hist_ignore_dups   # 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_all_dups  # 重複したヒストリは追加しない
setopt hist_ignore_space # スペースから始まるコマンド行はヒストリに残さない
setopt magic_equal_subst
setopt auto_list  # 補完候補が複数ある時に、一覧表示
setopt ignore_eof # Ctrl+Dでzshを終了しない

bindkey "^[[3~" delete-char # Deleteを使えるように
# }}}

# environments {{{
export PATH="$HOME/.anyenv/bin:$PATH"
export PATH=$HOME/.anyenv/envs/nodenv/versions/12.18.3/bin/:$PATH
eval "$(anyenv init - zsh)"
export PATH="/home/ucpr/.local/bin:$PATH"
export GOPATH="$HOME/Works/.go"
export PATH="/home/ucpr/Works/.go/bin:$PATH"

export DAIZU_AUTH0_DOMAIN="soybeanslab.auth0.com"
export DAIZU_AUTH0_API_AUDIENCE="https://soybeanslab.auth0.com/api/v2/"

export WINIT_UNIX_BACKEND=x11

export LESS='-RNMS'

export VISUAL="vim"
# }}}

# aliases {{{
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
alias p="python"
alias py-reqirements='pip freeze > requirements.txt'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias pdf-apvlv='apvlv'

alias e2j='trans en:ja'
alias j2e='trans ja:en'

ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() { curl -L -s https://www.gitignore.io/api/$@ ; }

# fzf
export FZF_DEFAULT_OPTS="--no-sort --exact --cycle --multi --ansi --reverse --border --sync --bind=ctrl-t:toggle --bind=ctrl-k:kill-line --bind=?:toggle-preview --bind=down:preview-down --bind=up:preview-up"

function tree_select() {
  tree -N -a --charset=o -f -I '.git|.idea|resolution-cache|target/streams|node_modules|.*' | \
    fzf --preview 'f() {
      set -- $(echo -- "$@" | grep -o "\./.*$");
      if [ -d $1 ]; then
        ls -lh $1
      else
        head -n 100 $1
      fi
    }; f {}' | \
      sed -e "s/ ->.*\$//g" | \
      tr -d '\||`| ' | \
      tr '\n' ' ' | \
      sed -e "s/--//g" | \
      xargs echo
}

function tree_select_buffer(){
  local SELECTED_FILE=$(tree_select)
  if [ -n "$SELECTED_FILE" ]; then
    LBUFFER+="$SELECTED_FILE"
    CURSOR=$#LBUFFER
    zle reset-prompt
  fi
}
zle -N tree_select_buffer
bindkey "^t" tree_select_buffer  # ctrl + t

function open_from_tree_vim(){
  local selected_file=$(tree_select)
  if [ -n "$selected_file" ]; then
    BUFFER="vim $selected_file"
  fi
  zle accept-line
}
zle -N open_from_tree_vim
bindkey "^v^t" open_from_tree_vim

function select_cdr(){
    local selected_dir=$(cdr -l | awk '{ print $2 }' | \
      fzf --preview 'f() { sh -c "ls -hFGl $1" }; f {}')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N select_cdr
bindkey '^@' select_cdr

# proxy
set_proxy() {
  export http_proxy="http://cproxy.okinawa-ct.ac.jp:8080"
  export https_prxoy=$http_proxy
  export ftp_proxy=$http_proxy
  export HTTP_PROXY=$http_proxy
  export HTTPS_PROXY=$http_proxy
  export FTP_PROXY=$http_proxy
  export no_proxy=localhost,127.0.0.1
  export NO_PROXY=$no_proxy

#  apm config set https-proxy $http_proxy
#  apm config set https-proxy $http_proxy
  git config --global http.proxy $http_proxy
  npm config set proxy $http_proxy
  npm config set https-proxy $http_proxy
  alias sudo="sudo -E"
  if [ -f ~/.curlrc.conf ]; then
    mv ~/.curlrc.conf ~/.curlrc
  fi
  if [ -f ~/.wgetrc.conf ]; then
    mv ~/.wgetrc.conf ~/.wgetrc
  fi
  echo "Proxy environment variable set."
}

unset_proxy() {
  unset http_proxy
  unset https_prxoy
  unset HTTP_PROXY
  unset HTTPS_PROXY

  git config --global --unset http.proxy
  npm config delete proxy
  npm config delete https-proxy
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

#function get_ssid() {
#    echo `nmcli dev status | grep 'ajima' | awk '{print $4}'`
#}

#export switch_tori=ajima
#echo `get_ssid`

#if [ "`get_ssid`" = "$switch_tori" ]; then
#    echo -e "\e[31mSwitch to proxy for school network\e[m"
#    set_proxy
#else
#    echo -e "\e[36mUnset proxy settings\e[m"
#    unset_proxy
#fi

# }}}

# zinit {{{

#if [[ ! -d ~/.zinit ]]; then
#  mkdir ~/.zinit
#  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
#fi

source ~/.zinit/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ref: https://github.com/zdharma/zinit#loading-and-unloading
zinit ice wait'!1'; zinit load zdharma/fast-syntax-highlighting
#zinit ice wait'!0'; zinit load zsh-users/zsh-autosuggestions
zinit ice wait'!0'; zinit load zsh-users/zsh-completions
zinit ice wait'!1'; plugins=(… zsh-completions)
zinit ice wait'!1'; autoload -U compinit && compinit

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# }}}
