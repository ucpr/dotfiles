# history settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# cache directory for zwc files
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
ZSH_ZWC_CACHE_DIR="$XDG_CACHE_HOME/zsh/zwc"
mkdir -p "$ZSH_ZWC_CACHE_DIR"

function _zwc_cache_path() {
  local src="$1"
  local key="${src:A}"
  key="${key//\//-}"
  key="${key//[^A-Za-z0-9._-]/_}"
  echo "$ZSH_ZWC_CACHE_DIR/${key}.zwc"
}

function ensure_zcompiled {
  local src="$1"
  local zwc="$(_zwc_cache_path "$src")"

  if [[ ! -r "$zwc" || "$src" -nt "$zwc" ]]; then
    echo "\033[1;36mCompiling\033[m $src"
    # output file is the first arg (no -o)
    zcompile "$zwc" "$src"
  fi
}

# override source command (compile to cache, then source normally)
function source {
  ensure_zcompiled "$1"
  builtin source "$1"
}

# pre-compile zshrc itself
ensure_zcompiled ~/.zshrc

# common settings
export PATH="/opt/homebrew/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

# sheldon settings
# eval "$(sheldon source)"

cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
sheldon_cache="$cache_dir/sheldon.zsh"
sheldon_toml="$HOME/.config/sheldon/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  mkdir -p $cache_dir
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset cache_dir sheldon_cache sheldon_toml

source $XDG_CONFIG_HOME/zsh/plugins/fzf_lazy.zsh
