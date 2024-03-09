# Styles
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

# Options
setopt hist_ignore_dups   # 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_all_dups  # 重複したヒストリは追加しない
setopt hist_ignore_space # スペースから始まるコマンド行はヒストリに残さない
setopt magic_equal_subst
setopt auto_list  # 補完候補が複数ある時に、一覧表示
setopt ignore_eof # Ctrl+Dでzshを終了しない

# Hooks
zshaddhistory() {
  local line="${1%%$'\n'}"
  [[ ! "$line" =~ "^(cd|jj?|la|ll|ls|rm)($| )" ]]
}

# Bindings
bindkey "^[[3~" delete-char
bindkey -v

# Modules
zmodload zsh/zpty
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^O" edit-command-line
