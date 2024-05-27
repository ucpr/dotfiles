local function list_github_plugins()
  local scriptnames = vim.fn.execute(':scriptnames')
  local lines = vim.split(scriptnames, '\n')

  local github_repos = {}
  local seen = {}

  for _, line in ipairs(lines) do
    local match = line:match("github%.com/[^/]+/[^/]+")
    if match and not seen[match] then
      seen[match] = true
      table.insert(github_repos, match)
    end
  end

  if #github_repos > 0 then
    print("Loaded plugins from github.com (" .. #github_repos .. "):")
    for index, repo in ipairs(github_repos) do
      print(index .. ". " .. repo)
    end
  else
    print("No plugins from github.com are loaded.")
  end
end

vim.api.nvim_create_user_command('ListGitHubPlugins', list_github_plugins, {})
