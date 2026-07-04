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
bindkey '^p' ghq-fzf

wezterm-workspace-fzf() {
  local result action workspace answer current_pane
  local -a pane_ids

  if ! command -v wezterm >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
    zle -R -c
    return 1
  fi

  result=$(
    wezterm cli list --format json |
      jq -r '
        sort_by(.workspace)
        | group_by(.workspace)[]
        | .[0].workspace + "\t" + (length | tostring) + " panes\t" + ((map(select(.is_active == true))[0].title // .[0].title // ""))
      ' |
      fzf --no-multi \
        --delimiter=$'\t' \
        --prompt="WezTerm Workspace > " \
        --header=$'ENTER: switch   CTRL-N: create from query   CTRL-D: delete selected\nESC: cancel' \
        --bind 'enter:become(printf "%s\t%s\n" switch {1})' \
        --bind 'ctrl-n:become(printf "%s\t%s\n" create {q})' \
        --bind 'ctrl-d:become(printf "%s\t%s\n" delete {1})'
  ) || {
    zle -R -c
    return 0
  }

  action="${result%%$'\t'*}"
  workspace="${result#*$'\t'}"

  case "$action" in
    create)
      workspace=$(printf '%s' "$workspace" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      if [[ -n "$workspace" ]]; then
        wezterm-switch-workspace "$workspace"
      fi
      ;;
    switch)
      if [[ -n "$workspace" ]]; then
        wezterm-switch-workspace "$workspace"
      fi
      ;;
    delete)
      if [[ -n "$workspace" ]]; then
        print -n -- "Delete WezTerm workspace '$workspace' by closing all panes? [y/N] "
        read -q answer
        print
        if [[ "$answer" == [yY] ]]; then
          current_pane="${WEZTERM_PANE:-}"
          pane_ids=("${(@f)$(
            wezterm cli list --format json |
              jq -r --arg workspace "$workspace" --arg current_pane "$current_pane" '
                map(select(.workspace == $workspace))
                | sort_by(if (.pane_id | tostring) == $current_pane then 1 else 0 end)
                | .[].pane_id
              '
          )}")
          for pane_id in "${pane_ids[@]}"; do
            wezterm cli kill-pane --pane-id "$pane_id"
          done
        fi
      fi
      ;;
  esac

  zle -R -c
}
zle -N wezterm-workspace-fzf
bindkey '^S' wezterm-workspace-fzf
bindkey -M viins '^S' wezterm-workspace-fzf
bindkey -M vicmd '^S' wezterm-workspace-fzf

wezterm-switch-workspace() {
  local workspace="$1"
  local payload encoded

  payload="${workspace}"$'\t'"${PWD}"$'\t'"$$-${RANDOM}"
  encoded=$(printf '%s' "$payload" | base64 | tr -d '\n')
  printf '\033]1337;SetUserVar=switch_workspace=%s\007' "$encoded"
}

# 現在のブランチで変更されたファイル（コミット済み含む）を選択
uncommited-staged-files() {
  # local f=$(git diff --name-only --diff-filter=d | awk '{print}' | fzf --preview 'f(){ sh -c "head -n 100 $1"}; f {}' | xargs echo)
  # main/masterブランチとの差分 + 未コミットの変更を取得
  local base_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "master")
  local f=$({ git diff --name-only ${base_branch}...HEAD --diff-filter=d; git status -s --no-renames | grep -v "D" | awk '{$1=$1};1' | cut -d " " -f 2; } | sort -u | fzf --preview 'f(){ sh -c "head -n 100 $1"}; f {}' | xargs echo)
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

fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
    echo "${pid}" | xargs kill "-${1:-9}"
  fi
}

bcheckout() {
  local tags branches target
  branches=$(
    git --no-pager branch --all \
      --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
    | sed '/^$/d') || return
  tags=$(
    git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
  target=$(
    (echo "$branches"; echo "$tags") |
    fzf --no-hscroll --no-multi -n 2 \
        --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'") || return
  git checkout $(awk '{print $2}' <<<"$target" )
}
zle -N bcheckout
bindkey '^B' bcheckout

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | delta'"

# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow_preview - git commit browser with previews
fshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

open_tracked_files() {
  projectRoot=$(git rev-parse --show-toplevel)
  fname=$(git ls-files "${projectRoot}" | fzf --preview "bat ${projectRoot}/{-1}")
  if [[ $fname != "" ]] then
    vim "${projectRoot}/${fname}"
  fi
}
zle -N open_tracked_files
bindkey '^f' open_tracked_files

open_all_files() {
  projectRoot=$(git rev-parse --show-toplevel)
  fname=$(find "${projectRoot}/*" -type f -not -path ".git/*" | sed -e "s%${projectRoot}/%%" | fzf --preview "bat ${projectRoot}/{-1}")
  if [[ $fname != "" ]]; then
    vim "${projectRoot}/${fname}"
  fi
}
zle -N open_all_files
bindkey '^a' open_all_files

prs() {
  number=$(gh pr list --json number,title,author | jq -r '.[] | "#" + (.number|tostring) + "\t" + .title + " / @" + .author.login' | fzf |grep -o -E "[1-9]+\d" | head -n1)
  if [[ $number != "" ]]; then
    gh pr view -w -- "${number}"
  fi
}

issues() {
  number=$(gh issue list --json number,title,author | jq -r '.[] | "#" + (.number|tostring) + "\t" + .title + " / @" + .author.login'| fzf |grep -o -E "[0-9]+" | head -n1)
  if [[ $number != "" ]]; then
    gh issue view -w -- "${number}"
  fi
}
