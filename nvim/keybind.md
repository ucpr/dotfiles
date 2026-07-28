# Neovim Keybindings

## Leader Key
- Leader key is set to `<space>` (スペースキー)

## <leader> (Space) Keybindings

### AI/Sidekick (`<leader>a`)
- `<leader>a` - AI/Sidekick prefix
- `<leader>aa` - Toggle Sidekick CLI
- `<leader>ac` - Toggle Claude
- `<leader>af` - Focus Claude
- `<leader>ar` - Resume Claude
- `<leader>ad` - Close Sidekick CLI
- `<leader>aC` - Continue Claude
- `<leader>ab` - Send current file to Claude
- `<leader>as` - Send selection to Claude (visual mode)
- `<leader>ap` - Select Sidekick prompt
- `<C-.>` - Focus Sidekick CLI

### Code Actions (`<space>ca`)
- `<space>ca` - Code actions (normal and visual mode)

### LSP Workspace
- `<space>wa` - Add workspace folder
- `<space>wr` - Remove workspace folder
- `<space>wl` - List workspace folders
- `<space>D` - Type definition
- `<space>e` - Show line diagnostics
- `<space>q` - Set loclist

### Telescope
- `<space>ff` - Fuzzy find files in cwd
- `<space>g` - Live grep
- `<space>b` - Buffers
- `<space>gs` - Git status
- `<space>gc` - Git commits

### TreeSJ (Split/Join)
- `<space>m` - Toggle split/join

## Other Important Keybindings

### General
- `<C-q>` - Quit without saving

### Buffer Navigation
- `,` - Previous buffer
- `.` - Next buffer

### Tab Navigation
- `tl` - Next tab
- `th` - Previous tab
- `<C-t>` - New tab

### Window Navigation
- `<C-h>` - Move to left window
- `<C-j>` - Move to bottom window
- `<C-k>` - Move to top window
- `<C-l>` - Move to right window

### Terminal Mode
- `<C-@>` - Exit terminal mode to normal mode
- `<C-q>` - Exit terminal
- `<Esc>` - Exit terminal mode to normal mode
- `T` - Toggle FTerm

### LSP Navigation
- `gD` - Go to declaration
- `gd` - Go to definition
- `gvd` - Go to definition in vertical split
- `gsd` - Go to definition in horizontal split
- `gi` - Go to implementation
- `gr` - Go to references
- `gt` - Go to type definition
- `gn` - Rename
- `gf` - Format
- `ge` - Open float diagnostic
- `<C-k>` - Signature help
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### File Explorer (Oil)
- `-` - Open parent directory (Oil)
- `g?` - Show help (in Oil)
- `<CR>` - Select
- `<C-s>` - Select in vertical split
- `<C-h>` - Select in horizontal split
- `<C-t>` - Select in new tab
- `<C-p>` - Preview
- `<C-c>` - Close
- `<C-l>` - Refresh
- `_` - Open cwd
- `` ` `` - cd to directory
- `~` - tcd to directory
- `gs` - Change sort
- `gx` - Open external
- `g.` - Toggle hidden files
- `g\` - Toggle trash

### Search (Pounce)
- `s` - Pounce search

### Treesitter
- `<C-space>` - Init/increment selection
- `<bs>` - Decrement selection

### Custom Scripts
- `got` - Run Go test

### User Commands
- `:Sterm` - Split terminal (horizontal)
- `:Vterm` - Vertical split terminal
