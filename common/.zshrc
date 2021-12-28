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

bindkey "^[[3~" delete-char

alias g="git"
alias k="kubectl"
alias kctx="kubectx"
alias kns="kubens"

alias ls='ls --color=auto'
alias la="ls -a"
alias ll="ls -l"
alias sl='ls'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias e2j='trans en:ja'
alias j2e='trans ja:en'

export GOPATH=~/.go
export PATH=~/.go/bin:$PATH

ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() {
    curl -L -s https://www.gitignore.io/api/$@
}

# fzf setting
export FZF_DEFAULT_OPTS="--no-sort --exact --cycle --multi --ansi --reverse --border --sync --bind=ctrl-t:toggle --bind=ctrl-k:kill-line --bind=?:toggle-preview --bind=down:preview-down --bind=up:preview-up"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
export FZF_DEFAULT_OPTS='--bind ctrl-j:down,ctrl-k:up'

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

select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^f' ghq-fzf

uncommited-staged-files() {
  local f=$(git diff --name-only --diff-filter=d | awk '{print}' | fzf --preview 'f(){ sh -c "head -n 100 $1"}; f {}' | xargs echo)
  if [ -n "$f" ]; then
    BUFFER="vim ${f}"
    zle accept-line
  fi
}
zle -N uncommited-staged-files
bindkey '^U' uncommited-staged-files

gcloud-switch-project() {
  local f=$(gcloud config configurations list | awk '{if($1 != "NAME") {print $1}}' | fzf --preview "" | xargs echo)
  gcloud config configurations activate "${f}"
}

# zinit
source ~/.zinit/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ref: https://github.com/zdharma/zinit#loading-and-unloading
zinit ice wait'!1'; zinit load zdharma-continuum/fast-syntax-highlighting
zinit ice wait'!0'; zinit load zsh-users/zsh-autosuggestions
zinit ice wait'!0'; zinit load zsh-users/zsh-completions
zinit ice wait'!1'; plugins=(… zsh-completions)
zinit ice wait'!1'; autoload -U compinit && compinit

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
