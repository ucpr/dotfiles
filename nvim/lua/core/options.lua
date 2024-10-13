local options = {
  -- file encoding
  encoding = "utf-8",
  fileencodings = "utf-8,iso-2022-jp,cp932,sjis,euc-jpset",
  fencs = "utf-8,iso-2022-jp,enc-jp,cp932",

  -- etc
  confirm = true,
  hidden = true,
  foldmethod = "marker", -- 折りたたみ
  display = "uhex",
  writebackup = true,
  infercase = true, -- 補完時に大文字小文字区別しない
  autoread = true,
  backspace = "eol,indent,start",
  signcolumn = "yes",
  mouse = "a",
  -- pastetoggle = "<F5>",
  helplang = "ja",

  -- theme
  spell = false, -- spelunker.vim を使うためfalseにする
  title = false,
  number = true,
  cursorline = false,
  cursorcolumn = false,
  showmatch = true,
  wildmenu = true,
  list = true,
  listchars = {
    tab = "»-",
    eol = "¬",
    extends = "»",
    precedes = "«",
  },
  termguicolors = true,
  cmdheight = 0,
  laststatus = 2,
  showtabline = 2,
  -- statusline = '%f %y%m %r%h%w%=[%{&fileencoding!=""?&fileencoding:&encoding},%{&ff}] [Pos %02l,%02c] [%p%%/%L]',
  -- pumblend = 30,
  winblend = 5,
  -- syntax
  tabstop = 2,
  shiftwidth = 2,
  smarttab = true,
  smartindent = true,
  expandtab = true,
  -- search
  hlsearch = true,
  ignorecase = true,
  smartcase = true,
  wrapscan = true,
}

vim.opt.completeopt:remove({ "preview" })
vim.opt.clipboard:append({ "unnamedplus" })
for k, v in pairs(options) do
  vim.opt[k] = v
end

-- cmdline.vim でこれを入れていないと statusline の下のコマンドでも cursor が動き回る
-- vim.cmd [[
--   set guicursor=n-v-c-sm:block-Cursor
--   set guicursor+=i:ver25-CursorInsert
-- ]]
