--
vim.keymap.set("n", "<C-q>", ":<C-u>q!<CR>")

-- buffer
vim.keymap.set("n", ",", ":<C-u>bprev<CR>")
vim.keymap.set("n", ".", ":<C-u>bnext<CR>")

-- tab
vim.keymap.set("n", "tl", ":<C-u>tabn<CR>")
vim.keymap.set("n", "th", ":<C-u>tabp<CR>")
vim.keymap.set("n", "<C-t>", ":<C-u>tabnew<CR>")

-- window
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- terminal mode
vim.keymap.set("t", "<C-@>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-q>", "exit<CR>")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- custom script
vim.keymap.set("n", "got", ":<C-u>lua go_test()<CR>")

-- vim-smartword
vim.keymap.set("n", "w", "<Plug>(smartword-w)")
