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
