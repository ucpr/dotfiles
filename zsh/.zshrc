# history settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# use compiled zshrc
ZSHRC_DIR=${${(%):-%N}:A:h}
function source { # override source command
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "\033[1;36mCompiling\033[m $1"
    zcompile $1
  fi
}
ensure_zcompiled ~/.zshrc

# common settings
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"

# sheldon settings
eval "$(sheldon source)"

#cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
#sheldon_cache="$cache_dir/sheldon.zsh"
#sheldon_toml="$HOME/.config/sheldon/plugins.toml"
#if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
#  mkdir -p $cache_dir
#  sheldon source > $sheldon_cache
#fi
#source "$sheldon_cache"
#unset cache_dir sheldon_cache sheldon_toml
