### Zinit
# ref: https://github.com/zdharma/zinit#loading-and-unloading
zinit ice wait'!1'; zinit load zdharma-continuum/fast-syntax-highlighting
zinit ice wait'!0'; zinit load zsh-users/zsh-autosuggestions
zinit ice wait'!0'; zinit load zsh-users/zsh-completions
zinit ice wait'!1'; plugins=(… zsh-completions)
zinit ice wait'!1'; autoload -U compinit && compinit

### Aliases
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

### Export
export GOPATH=~/.go
export PATH=~/.go/bin:$PATH

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

### Functions
ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() {
    curl -L -s https://www.gitignore.io/api/$@
}

### fzf
export FZF_DEFAULT_OPTS="--height 40% --border --reverse --no-sort --exact --cycle --multi --ansi --sync --bind=ctrl-t:toggle --bind=ctrl-k:kill-line --bind=?:toggle-preview --bind=down:preview-down --bind=up:preview-up"
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
#export FZF_DEFAULT_OPTS='--bind ctrl-j:down,ctrl-k:up'

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

# statingされていないfileをvimで楽に開けるようにする
uncommited-staged-files() {
  local f=$(git diff --name-only --diff-filter=d | awk '{print}' | fzf --preview 'f(){ sh -c "head -n 100 $1"}; f {}' | xargs echo)
  if [ -n "$f" ]; then
    BUFFER="vim ${f}"
    zle accept-line
  fi
}
zle -N uncommited-staged-files
bindkey '^U' uncommited-staged-files

# gcloudのconfigを楽に切り替えるコマンド
gcloud-switch-project() {
  local f=$(gcloud config configurations list | awk '{if($1 != "NAME") {print $1}}' | fzf --preview "" | xargs echo)
  gcloud config configurations activate "${f}"
}

# git logを見ながらinteractiveにgit checkoutを行う
icheckout() {
  git checkout $(git branch -a | tr -d " " |fzf --height 100% --prompt "CHECKOUT BRANCH>" --preview "git log --color=always {}" | head -n 1 | sed -e "s/^\*\s*//g" | perl -pe "s/remotes\/origin\///g")
}

### asdf
source /usr/local/opt/asdf/asdf.sh
