ggl() {
    open "https://google.com/search?q=${*// /%20}"
}

gignore() {
    curl -L -s "https://www.gitignore.io/api/$@"
}

git-worktree-switcher() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Not in a git repository"
        return 1
    fi

    local worktrees=$(git worktree list | awk '{print $1}')
    local selected=$(echo "$worktrees" | fzf --prompt="Select worktree (ESC to create new): " --header="Git Worktrees" --preview="git -C {} log --oneline -n 10" --preview-window=right:50%)

    if [[ -n "$selected" ]]; then
        cd "$selected"
    else
        echo -n "Enter branch name for new worktree: "
        read branch_name
        if [[ -z "$branch_name" ]]; then
            echo "Branch name cannot be empty"
            return 1
        fi

        echo -n "Enter path for new worktree (default: ../$branch_name): "
        read worktree_path
        if [[ -z "$worktree_path" ]]; then
            worktree_path="../$branch_name"
        fi

        if git worktree add "$worktree_path" -b "$branch_name"; then
            cd "$worktree_path"
        else
            echo "Failed to create worktree"
            return 1
        fi
    fi
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
