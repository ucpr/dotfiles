return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("onedark").setup {
          style = "darker",
          transparent = true,           -- Show/hide background
          term_colors = true,           -- Change terminal color as per the selected theme style
          ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
          cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
          code_style = {
            comments = 'italic',
            keywords = 'none',
            functions = 'none',
            strings = 'none',
            variables = 'bold'
          },
          -- Custom Highlights --
          colors = {},     -- Override default colors
          highlights = {}, -- Override highlight groups
          -- Plugins Config --
          diagnostics = {
            darker = true,     -- darker colors for diagnostic
            undercurl = true,  -- use undercurl instead of underline for diagnostics
            background = true, -- use background color for virtual text
          },
        }
        require("onedark").load()
    end,
}
