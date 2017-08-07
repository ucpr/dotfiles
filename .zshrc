# ヒストリの設定 {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# }}}

# zstyle {{{
# 大文字小文字区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 上下左右に補完選択
zstyle ':completion:*:default' menu select=2
# 補完候補に色を付ける
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2
# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..
# キャッシュを使ってコマンド高速化
zstyle ':completion:*' use-cache true
# 上下左右に補完選択
zstyle ':completion:*:default' menu select=2
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

# PATH {{{
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

export GOPATH="$HOME/.go"

export PATH="/home/nve3pd/.gem/ruby/2.4.0/bin:$PATH"
export PATH="/usr/bin/python2:$PATH"

export XDG_CONFIG_HOME=$HOME/.config

export VISUAL="vim"
# }}}

# その他 {{{
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
bindkey "^[[3~" delete-char # Deleteを使えるように
eval `dircolors ~/.config/color/dircolors-solarized/dircolors.ansi-dark`
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
zplug "mrowa44/emojify", as:command

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose
# }}}

# function {{{
function set_proxy() {
  export http_proxy="http://proxy:8888"
  export https_prxoy=$http_proxy
  apm config set https-proxy $http_proxy
  apm config set https-proxy $http_proxy
  git config --global http.proxy $http_proxy
  if [ -f ~/.curlrc.conf ]; then 
    mv ~/.curlrc.conf ~/.curlrc
  fi
  if [ -f ~/.wgetrc.conf ]; then 
    mv ~/.wgetrc.conf ~/.wgetrc
  fi
  echo "Proxy environment variable set."
}

function unset_proxy() {
  unset http_proxy
  unset https_prxoy
  git config --global --unset http.proxy
  apm config delete http-proxy
  apm config delete https-proxy
  if [ -f ~/.curlrc ]; then 
    mv ~/.curlrc ~/.curlrc.conf
  fi
  if [ -f ~/.wgetrc ]; then 
    mv ~/.wgetrc ~/.wgetrc.conf
  fi
  echo -e "Proxy environment variable removed."
}
# }}}
