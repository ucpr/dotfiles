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

# load zsh configuration {{{
ZSHHOME="${HOME}/.zsh.d"

if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
  for i in $ZSHHOME/*; do
    [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi
# }}}

# proxy {{{
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
