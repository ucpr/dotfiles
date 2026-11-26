export GOPATH=~/.go
export PATH=~/.go/bin:$PATH

export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export PATH="${HOME}/.codeium/windsurf/bin:$PATH"

export VISUAL=nvim
export EDITOR=nvim

export CLAUDE_CONFIG_DIR="${HOME}/.config/claude/"
export PATH="$HOME/.local/bin:$PATH"

rex_bin_dir="$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS"
if [[ -x "$rex_bin_dir/rex" ]]; then
  export REX_BIN_DIR="$rex_bin_dir"
  export PATH="$REX_BIN_DIR:$PATH"
fi
unset rex_bin_dir
