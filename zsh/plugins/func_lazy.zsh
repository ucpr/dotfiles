ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() {
    curl -L -s "https://www.gitignore.io/api/$@"
}

git_wt_fzf() {
  local line target key

  line="$(git wt | tail -n +2 | fzf --ansi \
    --prompt='git wt> ' \
    --header=$'ENTER: switch/create   CTRL-D: delete(safe)   CTRL-X: delete(force)   CTRL-N: new\nESC: cancel' \
    --expect=enter,ctrl-d,ctrl-x,ctrl-n
  )" || return

  key="$(printf '%s\n' "$line" | head -n1)"
  target="$(printf '%s\n' "$line" | tail -n1 | awk '{print $(NF-1)}')"

  case "$key" in
    ctrl-n)
      printf "new branch/worktree name: "
      read -r target
      [ -n "$target" ] && git wt "$target"
      ;;
    ctrl-d)
      [ -n "$target" ] && git wt -d "$target"
      ;;
    ctrl-x)
      [ -n "$target" ] && git wt -D "$target"
      ;;
    enter|"")
      [ -n "$target" ] && git wt "$target"
      ;;
  esac
}

osascript-system-notify() {
    local title="${1:-Notification}"
    local message="${2:-Message}"
    local subtitle="${3:-}"
    local sound="${4:-}"
    
    # Check if terminal-notifier is available
    if command -v terminal-notifier &> /dev/null; then
        # Use terminal-notifier for better notification features
        local cmd="terminal-notifier -title \"$title\" -message \"$message\""
        
        if [[ -n "$subtitle" ]]; then
            cmd="$cmd -subtitle \"$subtitle\""
        fi
        
        if [[ -n "$sound" ]]; then
            cmd="$cmd -sound \"$sound\""
        fi
        
        # Add action to open WezTerm when clicked
        cmd="$cmd -activate \"com.github.wez.wezterm\""
        
        eval "$cmd"
    else
        # Fallback to AppleScript
        # Escape special characters for AppleScript
        escape_applescript() {
            local str="$1"
            # Escape backslashes first, then double quotes
            str="${str//\\/\\\\}"
            str="${str//\"/\\\"}"
            echo "$str"
        }
        
        title=$(escape_applescript "$title")
        message=$(escape_applescript "$message")
        
        local script="display notification \"$message\" with title \"$title\""
        
        if [[ -n "$subtitle" ]]; then
            subtitle=$(escape_applescript "$subtitle")
            script="$script subtitle \"$subtitle\""
        fi
        
        if [[ -n "$sound" ]]; then
            # Sound names should be validated against a whitelist
            # Common system sounds: Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
            sound=$(escape_applescript "$sound")
            script="$script sound name \"$sound\""
        fi
        
        # Use printf to safely pass the script to osascript
        printf '%s' "$script" | osascript
    fi
}
