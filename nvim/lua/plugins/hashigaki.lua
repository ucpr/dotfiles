return {
	dir = vim.fn.expand("~/.ghq/github.com/ucpr/hashigaki"),
	config = function()
		require("hashigaki").setup({
			command = "hashigaki",
			diagnostics = {
				enabled = true,
				virtual_text = false,
				signs = true,
				underline = false,
			},
			hover = {
				enabled = true,
				delay_ms = 800,
				width = 64,
				max_height = 14,
				border = "rounded",
			},
		})
	end,
}
