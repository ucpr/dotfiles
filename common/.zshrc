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

# zinit
source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# set theme
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit wait lucid light-mode as'null' \
  atinit'. "/Users/s11591/.config/zsh/plugin.zsh"' \
  for 'zdharma-continuum/null'
