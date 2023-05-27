-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/s11591/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/s11591/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/s11591/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/s11591/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/s11591/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FTerm.nvim"] = {
    config = { "\27LJ\2\nÅ\1\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\1K\0\1\0\15dimensions\1\0\2\vheight\4Õô≥Ê\fÃô≥ˇ\3\nwidth\4Õô≥Ê\fÃô≥ˇ\3\1\0\1\vborder\vdouble\nsetup\nFTerm\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/FTerm.nvim",
    url = "https://github.com/numToStr/FTerm.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-calc/after/plugin/cmp_calc.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-cmdline"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-document-symbol/after/plugin/cmp_nvim_lsp_document_symbol.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-signature-help/after/plugin/cmp_nvim_lsp_signature_help.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-path"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-vsnip"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/cmp-vsnip",
    url = "https://github.com/hrsh7th/cmp-vsnip"
  },
  ["context_filetype.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/context_filetype.vim",
    url = "https://github.com/Shougo/context_filetype.vim"
  },
  ["copilot.vim"] = {
    config = { "\27LJ\2\n\26\0\1\3\0\1\0\4'\1\0\0\18\2\0\0&\1\2\1L\1\2\0\a# ≥\2\1\0\14\0\16\0-6\0\0\0009\0\1\0009\0\2\0B\0\1\0026\1\0\0009\1\1\0019\1\3\1\18\3\0\0'\4\4\0B\1\3\0026\2\0\0009\2\1\0029\2\5\2'\4\6\0\18\5\1\0'\6\a\0&\4\6\4B\2\2\0026\3\b\0009\3\t\0036\5\0\0009\5\n\0053\a\v\0006\b\0\0009\b\f\b\18\n\2\0'\v\r\0B\b\3\0A\5\1\2'\6\r\0B\3\3\0026\4\0\0009\4\14\0049\4\15\4)\6\0\0)\aˇˇ)\bˇˇ+\t\1\0006\n\0\0009\n\f\n\18\f\3\0'\r\r\0B\n\3\0A\4\4\1K\0\1\0\23nvim_buf_set_lines\bapi\6\n\nsplit\0\ftbl_map\vconcat\ntable\19 diff --cached\fgit -C \vsystem\a:h\16fnamemodify\19FugitiveGitDir\afn\bvimö\2\1\0\a\0\f\0\0196\0\0\0009\0\1\0009\1\2\0'\3\3\0'\4\4\0'\5\5\0005\6\6\0B\1\5\0019\1\2\0'\3\3\0'\4\a\0'\5\b\0B\1\4\0013\1\t\0006\2\0\0009\2\n\2'\4\v\0B\2\2\1K\0\1\0U            autocmd BufReadPost COMMIT_EDITMSG call lua append_diff()\n          \bcmd\0\28<Plug>(copilot-dismiss)\n<C-x>\1\0\4\21replace_keycodes\1\vscript\2\texpr\2\vsilent\2\21copilot#Accept()\n<C-c>\6i\bset\vkeymap\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/copilot.vim",
    url = "https://github.com/github/copilot.vim"
  },
  ["denops.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/denops.vim",
    url = "https://github.com/vim-denops/denops.vim"
  },
  ["fuzzy-motion.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/fuzzy-motion.vim",
    url = "https://github.com/yuki-yano/fuzzy-motion.vim"
  },
  ["guise.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/guise.vim",
    url = "https://github.com/lambdalisue/guise.vim"
  },
  ["lexima.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/lexima.vim",
    url = "https://github.com/cohama/lexima.vim"
  },
  ["lspkind.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\nÓ\1\0\0\b\0\t\2'6\0\0\0\14\0\0\0X\1\2Ä6\0\1\0009\0\0\0007\0\0\0006\0\0\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\2\0009\2\3\0029\2\5\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\6\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\a\2'\5\b\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\ntable\vunpack\0\2p\0\2\n\0\4\0\0156\2\0\0009\2\1\0029\2\2\0026\4\0\0009\4\1\0049\4\3\4\18\6\0\0+\a\2\0+\b\2\0+\t\2\0B\4\5\2\18\5\1\0+\6\2\0B\2\4\1K\0\1\0\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim;\0\1\4\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\20vsnip#anonymous\afn\bvim«\3\0\2\4\2\20\0002-\2\0\0009\3\0\0018\2\3\2=\2\0\0019\2\1\0009\2\2\2\a\2\3\0X\2\6Ä-\2\1\0009\2\4\0029\2\5\2=\2\0\1'\2\a\0=\2\6\0019\2\1\0009\2\2\2\a\2\b\0X\2\6Ä-\2\1\0009\2\t\0029\2\n\2=\2\0\1'\2\v\0=\2\6\0019\2\1\0009\2\2\2\a\2\f\0X\2\6Ä-\2\1\0009\2\t\0029\2\r\2=\2\0\1'\2\14\0=\2\6\0019\2\1\0009\2\2\2\a\2\15\0X\2\6Ä-\2\1\0009\2\t\0029\2\16\2=\2\0\1'\2\17\0=\2\6\0015\2\19\0009\3\1\0009\3\2\0038\2\3\2=\2\18\1L\1\2\0\3¿\2¿\1\0\6\vbuffer\5\nemoji\5\tpath\5\fluasnip\5\rnvim_lua\5\rnvim_lsp\5\tmenu\24CmpItemKindConstant\17CircuitBoard\19lab.quick_data\21CmpItemKindCrate\fPackage\vcrates\21CmpItemKindEmoji\vSmiley\tmisc\nemoji\23CmpItemKindCopilot\18kind_hl_group\rOctoface\bgit\fcopilot\tname\vsource\tkindÂ\1\0\1\5\3\b\1 -\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\22Ä6\1\2\0009\1\3\0019\1\4\1)\3\1\0B\1\2\2\t\1\0\0X\1\5Ä-\1\1\0'\3\5\0'\4\6\0B\1\3\1X\1\nÄ-\1\2\0B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\a\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\4¿\1¿\0¿\rcomplete\5!<Plug>(vsnip-expand-or-jump)\20vsnip#available\afn\bvim\21select_next_item\fvisible\2®\1\0\0\4\2\a\1\21-\0\0\0009\0\0\0B\0\1\2\15\0\0\0X\1\4Ä-\0\0\0009\0\1\0B\0\1\1X\0\vÄ6\0\2\0009\0\3\0009\0\4\0)\2ˇˇB\0\2\2\t\0\0\0X\0\4Ä-\0\1\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\4¿\1¿\5\28<Plug>(vsnip-jump-prev)\19vsnip#jumpable\afn\bvim\21select_prev_item\fvisible\2Ô\t\1\0\15\0G\0ì\0013\0\0\0003\1\1\0006\2\2\0B\2\1\0029\3\3\0026\4\4\0'\6\5\0B\4\2\0029\5\6\0045\a\n\0005\b\b\0003\t\a\0=\t\t\b=\b\v\a5\b\r\0005\t\f\0=\t\14\b3\t\15\0=\t\16\b=\b\17\a5\b\22\0009\t\18\0049\t\19\t9\t\20\t5\v\21\0B\t\2\2=\t\23\b9\t\18\0049\t\19\t9\t\20\t5\v\24\0B\t\2\2=\t\25\b=\b\19\a4\b\6\0005\t\26\0>\t\1\b5\t\27\0>\t\2\b5\t\28\0>\t\3\b5\t\29\0>\t\4\b5\t\30\0>\t\5\b=\b\31\a9\b \0049\b!\b9\b\"\b5\n$\0009\v \0049\v#\vB\v\1\2=\v%\n9\v \0049\v&\vB\v\1\2=\v'\n9\v \0049\v(\vB\v\1\2=\v)\n9\v \0049\v*\vB\v\1\2=\v+\n9\v \0049\v,\v)\r\4\0B\v\2\2=\v-\n9\v \0049\v,\v)\r¸ˇB\v\2\2=\v.\n9\v \0049\v/\v5\r0\0B\v\2\2=\v1\n9\v \0043\r2\0005\0143\0B\v\3\2=\v4\n9\v \0043\r5\0005\0146\0B\v\3\2=\v7\nB\b\2\2=\b \a5\b8\0=\b9\aB\5\2\0019\5\6\0049\5:\5'\a;\0005\b>\0009\t\18\0049\t\31\t4\v\3\0005\f<\0>\f\1\v4\f\3\0005\r=\0>\r\1\fB\t\3\2=\t\31\bB\5\3\0019\5\6\0049\5?\0055\a@\0005\bA\0009\t \0049\t!\t9\t?\tB\t\1\2=\t \b4\t\3\0005\nB\0>\n\1\t=\t\31\bB\5\3\0019\5\6\0049\5?\5'\aC\0005\bD\0009\t \0049\t!\t9\t?\tB\t\1\2=\t \b9\t\18\0049\t\31\t4\v\3\0005\fE\0>\f\1\v4\f\3\0005\rF\0>\r\1\fB\t\3\2=\t\31\bB\5\3\0012\0\0ÄK\0\1\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\1\0\0\6:\1\0\1\tname\vbuffer\1\0\0\1\3\0\0\6/\6?\fcmdline\1\0\0\1\0\1\tname\vbuffer\1\0\1\tname\fcmp_git\14gitcommit\rfiletype\17experimental\1\0\1\15ghost_text\2\f<S-Tab>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-b>\n<C-f>\16scroll_docs\n<C-e>\nabort\n<C-l>\rcomplete\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\vinsert\vpreset\fmapping\fsources\1\0\2\tname\28nvim_lsp_signature_help\rpriority\3\6\1\0\2\tname\vbuffer\rpriority\3\a\1\0\2\tname\tpath\rpriority\3\b\1\0\2\tname\nvsnip\rpriority\3\t\1\0\2\tname\rnvim_lsp\rpriority\3\n\18documentation\1\0\1\vborder\vdouble\15completion\1\0\0\1\0\1\vborder\vdouble\rbordered\vwindow\vconfig\15formatting\vformat\0\vfields\1\0\0\1\4\0\0\tkind\tabbr\tmenu\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\bcmp\frequire\tkind\nicons\0\0\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-go"] = {
    config = { "\27LJ\2\n‰\1\0\0\5\0\t\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0004\3\3\0005\4\3\0>\4\1\3=\3\5\0025\3\6\0004\4\0\0=\4\a\3=\3\b\2B\0\2\1K\0\1\0\ndelve\targs\1\0\3\27initialize_timeout_sec\3\20\tport\f${port}\tpath\bdlv\23dap_configurations\1\0\0\1\0\4\ttype\ago\tmode\vremote\tname\18Attach remote\frequest\vattach\nsetup\vdap-go\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-dap-go",
    url = "https://github.com/leoluz/nvim-dap-go"
  },
  ["nvim-dap-ui"] = {
    config = { "\27LJ\2\nÇ\6\0\0\a\0\"\00126\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0026\3\n\0009\3\v\0039\3\f\3'\5\r\0B\3\2\2\b\3\0\0X\3\2Ä+\3\1\0X\4\1Ä+\3\2\0=\3\14\0024\3\3\0005\4\17\0005\5\16\0005\6\15\0>\6\1\5=\5\18\4>\4\1\0035\4\20\0005\5\19\0=\5\18\4>\4\2\3=\3\21\0025\3\22\0005\4\23\0=\4\5\3=\3\24\0025\3\25\0005\4\27\0005\5\26\0=\5\28\4=\4\t\3=\3\29\0025\3\30\0=\3\31\0025\3 \0=\3!\2B\0\2\1K\0\1\0\vrender\1\0\1\20max_value_lines\3d\fwindows\1\0\1\vindent\3\1\rfloating\nclose\1\0\0\1\3\0\0\6q\n<Esc>\1\0\1\vborder\vsingle\rcontrols\1\0\b\14step_into\bÔö∫\rstep_out\bÔöª\tplay\bÔÅã\14step_back\bÔÅà\npause\bÔÅå\rrun_last\b‚Üª\14step_over\bÔöº\14terminate\b‚ñ°\1\0\2\felement\trepl\fenabled\2\flayouts\1\0\2\tsize\4\0ÄÄ¿˛\3\rposition\vbottom\1\2\0\0\trepl\relements\1\0\2\tsize\3(\rposition\tleft\1\5\0\0\0\16breakpoints\vstacks\fwatches\1\0\2\aid\vscopes\tsize\4\0ÄÄ¿˛\3\17expand_lines\rnvim-0.7\bhas\afn\bvim\rmappings\vexpand\1\0\5\vremove\6d\tedit\6e\topen\6o\trepl\6r\vtoggle\6t\1\3\0\0\t<CR>\18<2-LeftMouse>\nicons\1\0\0\1\0\3\14collapsed\b‚ñ∏\18current_frame\b‚ñ∏\rexpanded\b‚ñæ\nsetup\ndapui\frequire\2\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_option\bapi\bvimÅ\v\1\2\v\0)\0w3\2\0\0003\3\1\0005\4\2\0\18\5\2\0'\a\3\0'\b\4\0'\t\5\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\6\0'\t\a\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\b\0'\t\t\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\n\0'\t\v\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\f\0'\t\r\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\14\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\16\0'\t\17\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\18\0'\t\19\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\20\0'\t\21\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\22\0'\t\23\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\24\0'\t\25\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\26\0'\t\27\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\28\0'\t\29\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\30\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\31\0'\t \0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b!\0'\t\"\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b#\0'\t$\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b%\0'\t&\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b'\0'\t(\0\18\n\4\0B\5\5\0012\0\0ÄK\0\1\0002<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>-<cmd>lua vim.diagnostic.open_float()<CR>\age5<cmd>lua vim.lsp.buf.format { async = true }<CR>\agf&<cmd>lua vim.lsp.buf.rename()<CR>\agn/<cmd>lua vim.lsp.buf.type_definition()<CR>\agt*<cmd>lua vim.lsp.buf.references()<CR>\agr.<cmd>lua vim.lsp.buf.implementation()<CR>\agi*<cmd>lua vim.lsp.buf.definition()<CR>\agd+<cmd>lua vim.lsp.buf.declaration()<CR>\agD%<cmd>lua vim.lsp.buf.hover()<CR>\6K\6n\1\0\2\vsilent\2\fnoremap\2\0\0ı\1\0\1\a\2\f\0\26\a\0\0\0X\1\16Ä-\1\0\0008\1\0\0019\1\1\0015\3\2\0-\4\1\0=\4\3\0035\4\4\0=\4\5\0035\4\t\0005\5\a\0005\6\6\0=\6\b\5=\5\0\4=\4\n\3B\1\2\1X\1\aÄ-\1\0\0008\1\0\0019\1\1\0015\3\v\0-\4\1\0=\4\3\3B\1\2\1K\0\1\0\3¿\0¿\1\0\0\rsettings\1\0\0\benv\1\0\1\fgofumpt\2\1\0\1\fGOFLAGS!-tags=integration,wireinject\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\nsetup\ngoplsì\3\0\1\17\0\18\00046\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\6\0005\3\5\0=\3\a\2=\2\4\0016\2\0\0009\2\1\0029\2\b\2)\4\0\0'\5\t\0\18\6\1\0\18\a\0\0B\2\5\0026\3\n\0\f\5\2\0X\5\1Ä4\5\0\0B\3\2\4H\6\26Ä6\b\n\0009\n\v\a\14\0\n\0X\v\1Ä4\n\0\0B\b\2\4H\v\17Ä9\r\f\f\15\0\r\0X\14\bÄ6\r\0\0009\r\1\r9\r\2\r9\r\r\r9\15\f\f'\16\14\0B\r\3\1X\r\6Ä6\r\0\0009\r\1\r9\r\15\r9\r\16\r9\15\17\fB\r\2\1F\v\3\3R\vÌ\127F\6\3\3R\6‰\127K\0\1\0\fcommand\20execute_command\bbuf\nUTF-8\25apply_workspace_edit\tedit\vresult\npairs\28textDocument/codeAction\21buf_request_sync\tonly\1\0\0\1\2\0\0\27source.organizeImports\fcontext\22make_range_params\tutil\blsp\bvimå\a\1\0\r\0(\0M3\0\0\0006\1\1\0'\3\2\0B\1\2\0029\1\3\1B\1\1\0029\2\4\0019\2\5\0029\2\6\2+\3\2\0=\3\a\0026\2\b\0009\2\t\0029\2\n\0026\3\b\0009\3\t\0039\3\f\0036\5\b\0009\5\t\0059\5\r\0059\5\14\0055\6\15\0B\3\3\2=\3\v\0025\2\16\0006\3\17\0\18\5\2\0B\3\2\4H\6\fÄ'\b\18\0\18\t\6\0&\b\t\b6\t\b\0009\t\19\t9\t\20\t\18\v\b\0005\f\21\0=\a\22\f=\b\23\f=\b\24\fB\t\3\1F\6\3\3R\6Ú\1276\3\1\0'\5\25\0B\3\2\0026\4\1\0'\6\26\0B\4\2\0029\4\27\0045\6\31\0005\a\29\0005\b\28\0=\b\30\a=\a \6B\4\2\0016\4\1\0'\6!\0B\4\2\0029\4\27\4B\4\1\0016\4\1\0'\6!\0B\4\2\0029\4\"\0044\6\3\0003\a#\0>\a\1\6B\4\2\0013\4$\0007\4%\0006\4\b\0009\4&\4'\6'\0B\4\2\0012\0\0ÄK\0\1\0h        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n      \bcmd\15OrgImports\0\0\19setup_handlers\20mason-lspconfig\aui\1\0\0\nicons\1\0\0\1\0\3\24package_uninstalled\b‚úó\20package_pending\b‚ûú\22package_installed\b‚úì\nsetup\nmason\14lspconfig\nnumhl\vtexthl\ttext\1\0\0\16sign_define\afn\19DiagnosticSign\npairs\1\0\4\tWarn\tÔî© \tHint\tÔ†µ \nError\tÔôô \tInfo\tÔëâ \1\0\4\nsigns\2\17virtual_text\2\14underline\2\21update_in_insert\1\27on_publish_diagnostics\15diagnostic\twith$textDocument/publishDiagnostics\rhandlers\blsp\bvim\19snippetSupport\19completionItem\15completion\17textDocument\25default_capabilities\17cmp_nvim_lsp\frequire\0\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    commands = { "NvimTreeToggle" },
    config = { "\27LJ\2\nŸ\1\0\0\4\0\f\0\0196\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\4\0'\2\5\0B\0\2\0029\0\6\0005\2\a\0005\3\b\0=\3\t\0025\3\n\0=\3\v\2B\0\2\1K\0\1\0\ffilters\1\0\1\rdotfiles\2\rrenderer\1\0\1\16group_empty\2\1\0\1\fsort_by\19case_sensitive\nsetup\14nvim-tree\frequire\23loaded_netrwPlugin\17loaded_netrw\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fÒ\2\1\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0003\4\a\0=\4\b\3=\3\t\0025\3\n\0=\3\v\2B\0\2\0016\0\f\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0008hi TreesitterContextBottom gui=underline guisp=Grey\bcmd\bvim\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2&additional_vim_regex_highlighting\1\venable\2\21ensure_installed\1\0\2\17auto_install\2\17sync_install\1\1\v\0\0\blua\ago\vpython\tbash\15typescript\tyaml\ttoml\tjson\bvim\bhcl\nsetup\28nvim-treesitter.configs\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "\27LJ\2\n˙\2\0\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\20\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3=\3\21\2B\0\2\1K\0\1\0\rpatterns\1\0\0\tyaml\1\2\0\0\23block_mapping_pair\15typescript\1\2\0\0\21export_statement\tjson\1\2\0\0\tpair\rmarkdown\1\2\0\0\fsection\14terraform\1\4\0\0\nblock\16object_elem\14attribute\trust\1\2\0\0\14impl_item\fhaskell\1\2\0\0\badt\fdefault\1\0\0\1\6\0\0\nclass\rfunction\vmethod\14interface\vstruct\nsetup\23treesitter-context\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["onedark.nvim"] = {
    config = { "\27LJ\2\nÿ\2\0\0\4\0\v\0\0206\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0024\3\0\0=\3\6\0024\3\0\0=\3\a\0025\3\b\0=\3\t\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\n\0B\0\1\1K\0\1\0\tload\16diagnostics\1\0\3\15background\2\14undercurl\2\vdarker\2\15highlights\vcolors\15code_style\1\0\5\rcomments\vitalic\14variables\tnone\fstrings\tnone\14functions\tnone\rkeywords\tnone\1\0\5\25cmp_itemkind_reverse\1\18ending_tildes\1\16term_colors\2\16transparent\2\nstyle\vwarmer\nsetup\fonedark\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/onedark.nvim",
    url = "https://github.com/navarasu/onedark.nvim"
  },
  ["openingh.nvim"] = {
    commands = { "OpenInGHFile", "OpenInGHRepo" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/openingh.nvim",
    url = "https://github.com/almo7aya/openingh.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["quick-scope"] = {
    config = { "\27LJ\2\nŸ\2\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0π\2        augroup qs_colors\n          autocmd!\n          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline\n          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline\n        augroup END\n      \bcmd\bvim\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["spelunker.vim"] = {
    config = { "\27LJ\2\n[\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\2\0=\1\3\0K\0\1\0\25spelunker_check_type\25enable_spelunker_vim\6g\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/spelunker.vim",
    url = "https://github.com/kamykn/spelunker.vim"
  },
  ["telescope-env.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/telescope-env.nvim",
    url = "https://github.com/LinArcX/telescope-env.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n˝\2\0\0\6\0\17\0\0226\0\0\0'\2\1\0B\0\2\0029\1\2\0005\3\6\0005\4\4\0005\5\3\0=\5\5\4=\4\a\0035\4\t\0005\5\b\0=\5\n\0045\5\v\0=\5\f\0045\5\r\0=\5\14\4=\4\15\3B\1\2\0019\1\16\0'\3\n\0B\1\2\1K\0\1\0\19load_extension\15extensions\19live_grep_args\1\0\1\17auto_quoting\2\17file_browser\1\0\1\17hijack_netrw\2\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\rdefaults\1\0\0\25file_ignore_patterns\1\0\0\1\6\0\0\vvendor\rvendor/*\r./vendor\15./vendor/*\17node_modules\nsetup\14telescope\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim",
    wants = { "telescope-fzf-native.nvim", "telescope-file-browser.nvim", "telescope-live-grep-args.nvim", "telescope-env.nvim" }
  },
  ["traces.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/traces.vim",
    url = "https://github.com/markonm/traces.vim"
  },
  ["vim-better-whitespace"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-better-whitespace",
    url = "https://github.com/ntpeters/vim-better-whitespace"
  },
  ["vim-fugitive"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-go-coverage"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-go-coverage",
    url = "https://github.com/kyoh86/vim-go-coverage"
  },
  ["vim-goaddtags"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-goaddtags",
    url = "https://github.com/mattn/vim-goaddtags"
  },
  ["vim-goimpl"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-goimpl",
    url = "https://github.com/mattn/vim-goimpl"
  },
  ["vim-goimports"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-goimports",
    url = "https://github.com/mattn/vim-goimports"
  },
  ["vim-gomod"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-gomod",
    url = "https://github.com/mattn/vim-gomod"
  },
  ["vim-sonictemplate"] = {
    commands = { "Template" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-sonictemplate",
    url = "https://github.com/mattn/vim-sonictemplate"
  },
  ["vim-vsnip"] = {
    config = { "\27LJ\2\n€\a\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ª\a        let g:vsnip_snippet_dir = \"$HOME/.config/nvim/snippets\"\n        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n\n        imap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        smap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        imap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        smap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        imap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        smap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        let g:vsnip_filetypes = {}\n        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)\n        \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  winresizer = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^FTerm"] = "FTerm.nvim",
  ["^lspconfig"] = "mason.nvim",
  ["^telescope"] = "telescope.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: vim-goimports
time([[Setup for vim-goimports]], true)
try_loadstring("\27LJ\2\n+\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\14goimports\6g\bvim\0", "setup", "vim-goimports")
time([[Setup for vim-goimports]], false)
-- Setup for: nvim-tree.lua
time([[Setup for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n`\0\0\5\0\6\0\b6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0B\0\4\1K\0\1\0&<C-\\><C-n><CMD>NvimTreeToggle<CR>\n<C-e>\6n\bset\vkeymap\bvim\0", "setup", "nvim-tree.lua")
time([[Setup for nvim-tree.lua]], false)
-- Setup for: copilot.vim
time([[Setup for copilot.vim]], true)
try_loadstring("\27LJ\2\nz\0\0\2\0\5\0\t6\0\0\0009\0\1\0005\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0\23copilot_no_tab_map\1\0\4\tyaml\2\ttext\2\14gitcommit\2\rmarkdown\2\22copilot_filetypes\6g\bvim\0", "setup", "copilot.vim")
time([[Setup for copilot.vim]], false)
-- Setup for: FTerm.nvim
time([[Setup for FTerm.nvim]], true)
try_loadstring("\27LJ\2\nk\0\0\5\0\6\0\b6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0B\0\4\1K\0\1\0005<C-\\><C-n><CMD>lua require(\"FTerm\").toggle()<CR>\6T\6n\bset\vkeymap\bvim\0", "setup", "FTerm.nvim")
time([[Setup for FTerm.nvim]], false)
-- Setup for: telescope.nvim
time([[Setup for telescope.nvim]], true)
try_loadstring("\27LJ\2\nM\0\0\3\2\2\0\n6\0\0\0'\2\1\0B\0\2\2-\1\0\0008\0\1\0-\2\1\0\14\0\2\0X\3\1Ä4\2\0\0D\0\2\0\0\0\0¿\22telescope.builtin\frequire\22\1\1\2\1\1\0\0033\1\0\0002\0\0ÄL\1\2\0\0¿\0\20\1\1\2\0\1\0\0033\1\0\0002\0\0ÄL\1\2\0\0y\0\0\4\3\4\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0-\3\0\0B\1\2\0019\1\3\0-\2\0\0008\1\2\1-\2\1\0008\1\2\1-\3\2\0\14\0\3\0X\4\1Ä4\3\0\0D\1\2\0\0\0\1\0\0¿\15extensions\19load_extension\14telescope\frequire\24\1\1\2\2\1\0\0033\1\0\0002\0\0ÄL\1\2\0\0¿\1¿\0\20\1\2\3\0\1\0\0033\2\0\0002\0\0ÄL\2\2\0\0¥\2\1\0\n\0\14\00013\0\0\0003\1\1\0006\2\2\0009\2\3\0029\2\4\2'\4\5\0'\5\6\0\18\6\0\0'\b\a\0B\6\2\0024\b\0\0B\6\2\0A\2\2\0016\2\2\0009\2\3\0029\2\4\2'\4\5\0'\5\b\0\18\6\1\0'\b\t\0'\t\t\0B\6\3\0024\b\0\0B\6\2\0A\2\2\0016\2\2\0009\2\3\0029\2\4\2'\4\5\0'\5\n\0\18\6\0\0'\b\v\0B\6\2\0024\b\0\0B\6\2\0A\2\2\0016\2\2\0009\2\3\0029\2\4\2'\4\5\0'\5\f\0\18\6\1\0'\b\r\0'\t\r\0B\6\3\0024\b\0\0B\6\2\0A\2\2\1K\0\1\0\19live_grep_args\14<Space>lg\15find_files\14<Space>ff\17file_browser\14<Space>fb\fbuffers\r<Space>b\6n\bset\vkeymap\bvim\0\0\0", "setup", "telescope.nvim")
time([[Setup for telescope.nvim]], false)
-- Setup for: vim-sonictemplate
time([[Setup for vim-sonictemplate]], true)
try_loadstring("\27LJ\2\nX\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\24$HOME/.vim/template#sonictemplate_vim_template_dir\6g\bvim\0", "setup", "vim-sonictemplate")
time([[Setup for vim-sonictemplate]], false)
-- Setup for: quick-scope
time([[Setup for quick-scope]], true)
try_loadstring("\27LJ\2\n®\1\0\0\2\0\a\0\0176\0\0\0009\0\1\0)\1\2\0=\1\2\0006\0\0\0009\0\1\0)\1P\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0K\0\1\0\1\3\0\0\rterminal\vnofile\25qs_buftype_blacklist\22qs_lazy_highlight\17qs_max_chars\19qs_hi_priority\6g\bvim\0", "setup", "quick-scope")
time([[Setup for quick-scope]], false)
time([[packadd for quick-scope]], true)
vim.cmd [[packadd quick-scope]]
time([[packadd for quick-scope]], false)
-- Config for: vim-vsnip
time([[Config for vim-vsnip]], true)
try_loadstring("\27LJ\2\n€\a\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ª\a        let g:vsnip_snippet_dir = \"$HOME/.config/nvim/snippets\"\n        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n\n        imap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        smap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        imap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        smap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        imap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        smap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        let g:vsnip_filetypes = {}\n        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)\n        \bcmd\bvim\0", "config", "vim-vsnip")
time([[Config for vim-vsnip]], false)
-- Config for: nvim-dap-go
time([[Config for nvim-dap-go]], true)
try_loadstring("\27LJ\2\n‰\1\0\0\5\0\t\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0004\3\3\0005\4\3\0>\4\1\3=\3\5\0025\3\6\0004\4\0\0=\4\a\3=\3\b\2B\0\2\1K\0\1\0\ndelve\targs\1\0\3\27initialize_timeout_sec\3\20\tport\f${port}\tpath\bdlv\23dap_configurations\1\0\0\1\0\4\ttype\ago\tmode\vremote\tname\18Attach remote\frequest\vattach\nsetup\vdap-go\frequire\0", "config", "nvim-dap-go")
time([[Config for nvim-dap-go]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fÒ\2\1\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0003\4\a\0=\4\b\3=\3\t\0025\3\n\0=\3\v\2B\0\2\0016\0\f\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0008hi TreesitterContextBottom gui=underline guisp=Grey\bcmd\bvim\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2&additional_vim_regex_highlighting\1\venable\2\21ensure_installed\1\0\2\17auto_install\2\17sync_install\1\1\v\0\0\blua\ago\vpython\tbash\15typescript\tyaml\ttoml\tjson\bvim\bhcl\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: quick-scope
time([[Config for quick-scope]], true)
try_loadstring("\27LJ\2\nŸ\2\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0π\2        augroup qs_colors\n          autocmd!\n          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline\n          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline\n        augroup END\n      \bcmd\bvim\0", "config", "quick-scope")
time([[Config for quick-scope]], false)
-- Config for: nvim-dap-ui
time([[Config for nvim-dap-ui]], true)
try_loadstring("\27LJ\2\nÇ\6\0\0\a\0\"\00126\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0026\3\n\0009\3\v\0039\3\f\3'\5\r\0B\3\2\2\b\3\0\0X\3\2Ä+\3\1\0X\4\1Ä+\3\2\0=\3\14\0024\3\3\0005\4\17\0005\5\16\0005\6\15\0>\6\1\5=\5\18\4>\4\1\0035\4\20\0005\5\19\0=\5\18\4>\4\2\3=\3\21\0025\3\22\0005\4\23\0=\4\5\3=\3\24\0025\3\25\0005\4\27\0005\5\26\0=\5\28\4=\4\t\3=\3\29\0025\3\30\0=\3\31\0025\3 \0=\3!\2B\0\2\1K\0\1\0\vrender\1\0\1\20max_value_lines\3d\fwindows\1\0\1\vindent\3\1\rfloating\nclose\1\0\0\1\3\0\0\6q\n<Esc>\1\0\1\vborder\vsingle\rcontrols\1\0\b\14step_into\bÔö∫\rstep_out\bÔöª\tplay\bÔÅã\14step_back\bÔÅà\npause\bÔÅå\rrun_last\b‚Üª\14step_over\bÔöº\14terminate\b‚ñ°\1\0\2\felement\trepl\fenabled\2\flayouts\1\0\2\tsize\4\0ÄÄ¿˛\3\rposition\vbottom\1\2\0\0\trepl\relements\1\0\2\tsize\3(\rposition\tleft\1\5\0\0\0\16breakpoints\vstacks\fwatches\1\0\2\aid\vscopes\tsize\4\0ÄÄ¿˛\3\17expand_lines\rnvim-0.7\bhas\afn\bvim\rmappings\vexpand\1\0\5\vremove\6d\tedit\6e\topen\6o\trepl\6r\vtoggle\6t\1\3\0\0\t<CR>\18<2-LeftMouse>\nicons\1\0\0\1\0\3\14collapsed\b‚ñ∏\18current_frame\b‚ñ∏\rexpanded\b‚ñæ\nsetup\ndapui\frequire\2\0", "config", "nvim-dap-ui")
time([[Config for nvim-dap-ui]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\n˙\2\0\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\20\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3=\3\21\2B\0\2\1K\0\1\0\rpatterns\1\0\0\tyaml\1\2\0\0\23block_mapping_pair\15typescript\1\2\0\0\21export_statement\tjson\1\2\0\0\tpair\rmarkdown\1\2\0\0\fsection\14terraform\1\4\0\0\nblock\16object_elem\14attribute\trust\1\2\0\0\14impl_item\fhaskell\1\2\0\0\badt\fdefault\1\0\0\1\6\0\0\nclass\rfunction\vmethod\14interface\vstruct\nsetup\23treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: spelunker.vim
time([[Config for spelunker.vim]], true)
try_loadstring("\27LJ\2\n[\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\2\0=\1\3\0K\0\1\0\25spelunker_check_type\25enable_spelunker_vim\6g\bvim\0", "config", "spelunker.vim")
time([[Config for spelunker.vim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_option\bapi\bvimÅ\v\1\2\v\0)\0w3\2\0\0003\3\1\0005\4\2\0\18\5\2\0'\a\3\0'\b\4\0'\t\5\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\6\0'\t\a\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\b\0'\t\t\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\n\0'\t\v\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\f\0'\t\r\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\14\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\16\0'\t\17\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\18\0'\t\19\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\20\0'\t\21\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\22\0'\t\23\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\24\0'\t\25\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\26\0'\t\27\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\28\0'\t\29\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\30\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\31\0'\t \0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b!\0'\t\"\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b#\0'\t$\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b%\0'\t&\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b'\0'\t(\0\18\n\4\0B\5\5\0012\0\0ÄK\0\1\0002<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>-<cmd>lua vim.diagnostic.open_float()<CR>\age5<cmd>lua vim.lsp.buf.format { async = true }<CR>\agf&<cmd>lua vim.lsp.buf.rename()<CR>\agn/<cmd>lua vim.lsp.buf.type_definition()<CR>\agt*<cmd>lua vim.lsp.buf.references()<CR>\agr.<cmd>lua vim.lsp.buf.implementation()<CR>\agi*<cmd>lua vim.lsp.buf.definition()<CR>\agd+<cmd>lua vim.lsp.buf.declaration()<CR>\agD%<cmd>lua vim.lsp.buf.hover()<CR>\6K\6n\1\0\2\vsilent\2\fnoremap\2\0\0ı\1\0\1\a\2\f\0\26\a\0\0\0X\1\16Ä-\1\0\0008\1\0\0019\1\1\0015\3\2\0-\4\1\0=\4\3\0035\4\4\0=\4\5\0035\4\t\0005\5\a\0005\6\6\0=\6\b\5=\5\0\4=\4\n\3B\1\2\1X\1\aÄ-\1\0\0008\1\0\0019\1\1\0015\3\v\0-\4\1\0=\4\3\3B\1\2\1K\0\1\0\3¿\0¿\1\0\0\rsettings\1\0\0\benv\1\0\1\fgofumpt\2\1\0\1\fGOFLAGS!-tags=integration,wireinject\nflags\1\0\1\26debounce_text_changes\3ñ\1\14on_attach\1\0\0\nsetup\ngoplsì\3\0\1\17\0\18\00046\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\6\0005\3\5\0=\3\a\2=\2\4\0016\2\0\0009\2\1\0029\2\b\2)\4\0\0'\5\t\0\18\6\1\0\18\a\0\0B\2\5\0026\3\n\0\f\5\2\0X\5\1Ä4\5\0\0B\3\2\4H\6\26Ä6\b\n\0009\n\v\a\14\0\n\0X\v\1Ä4\n\0\0B\b\2\4H\v\17Ä9\r\f\f\15\0\r\0X\14\bÄ6\r\0\0009\r\1\r9\r\2\r9\r\r\r9\15\f\f'\16\14\0B\r\3\1X\r\6Ä6\r\0\0009\r\1\r9\r\15\r9\r\16\r9\15\17\fB\r\2\1F\v\3\3R\vÌ\127F\6\3\3R\6‰\127K\0\1\0\fcommand\20execute_command\bbuf\nUTF-8\25apply_workspace_edit\tedit\vresult\npairs\28textDocument/codeAction\21buf_request_sync\tonly\1\0\0\1\2\0\0\27source.organizeImports\fcontext\22make_range_params\tutil\blsp\bvimå\a\1\0\r\0(\0M3\0\0\0006\1\1\0'\3\2\0B\1\2\0029\1\3\1B\1\1\0029\2\4\0019\2\5\0029\2\6\2+\3\2\0=\3\a\0026\2\b\0009\2\t\0029\2\n\0026\3\b\0009\3\t\0039\3\f\0036\5\b\0009\5\t\0059\5\r\0059\5\14\0055\6\15\0B\3\3\2=\3\v\0025\2\16\0006\3\17\0\18\5\2\0B\3\2\4H\6\fÄ'\b\18\0\18\t\6\0&\b\t\b6\t\b\0009\t\19\t9\t\20\t\18\v\b\0005\f\21\0=\a\22\f=\b\23\f=\b\24\fB\t\3\1F\6\3\3R\6Ú\1276\3\1\0'\5\25\0B\3\2\0026\4\1\0'\6\26\0B\4\2\0029\4\27\0045\6\31\0005\a\29\0005\b\28\0=\b\30\a=\a \6B\4\2\0016\4\1\0'\6!\0B\4\2\0029\4\27\4B\4\1\0016\4\1\0'\6!\0B\4\2\0029\4\"\0044\6\3\0003\a#\0>\a\1\6B\4\2\0013\4$\0007\4%\0006\4\b\0009\4&\4'\6'\0B\4\2\0012\0\0ÄK\0\1\0h        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n      \bcmd\15OrgImports\0\0\19setup_handlers\20mason-lspconfig\aui\1\0\0\nicons\1\0\0\1\0\3\24package_uninstalled\b‚úó\20package_pending\b‚ûú\22package_installed\b‚úì\nsetup\nmason\14lspconfig\nnumhl\vtexthl\ttext\1\0\0\16sign_define\afn\19DiagnosticSign\npairs\1\0\4\tWarn\tÔî© \tHint\tÔ†µ \nError\tÔôô \tInfo\tÔëâ \1\0\4\nsigns\2\17virtual_text\2\14underline\2\21update_in_insert\1\27on_publish_diagnostics\15diagnostic\twith$textDocument/publishDiagnostics\rhandlers\blsp\bvim\19snippetSupport\19completionItem\15completion\17textDocument\25default_capabilities\17cmp_nvim_lsp\frequire\0\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: onedark.nvim
time([[Config for onedark.nvim]], true)
try_loadstring("\27LJ\2\nÿ\2\0\0\4\0\v\0\0206\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0024\3\0\0=\3\6\0024\3\0\0=\3\a\0025\3\b\0=\3\t\2B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\n\0B\0\1\1K\0\1\0\tload\16diagnostics\1\0\3\15background\2\14undercurl\2\vdarker\2\15highlights\vcolors\15code_style\1\0\5\rcomments\vitalic\14variables\tnone\fstrings\tnone\14functions\tnone\rkeywords\tnone\1\0\5\25cmp_itemkind_reverse\1\18ending_tildes\1\16term_colors\2\16transparent\2\nstyle\vwarmer\nsetup\fonedark\frequire\0", "config", "onedark.nvim")
time([[Config for onedark.nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\nÓ\1\0\0\b\0\t\2'6\0\0\0\14\0\0\0X\1\2Ä6\0\1\0009\0\0\0007\0\0\0006\0\0\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\0A\0\0\3\b\1\0\0X\2\20Ä6\2\2\0009\2\3\0029\2\5\2)\4\0\0\23\5\1\0\18\6\0\0+\a\2\0B\2\5\2:\2\1\2\18\4\2\0009\2\6\2\18\5\1\0\18\6\1\0B\2\4\2\18\4\2\0009\2\a\2'\5\b\0B\2\3\2\n\2\0\0X\2\2Ä+\2\1\0X\3\1Ä+\2\2\0L\2\2\0\a%s\nmatch\bsub\23nvim_buf_get_lines\24nvim_win_get_cursor\bapi\bvim\ntable\vunpack\0\2p\0\2\n\0\4\0\0156\2\0\0009\2\1\0029\2\2\0026\4\0\0009\4\1\0049\4\3\4\18\6\0\0+\a\2\0+\b\2\0+\t\2\0B\4\5\2\18\5\1\0+\6\2\0B\2\4\1K\0\1\0\27nvim_replace_termcodes\18nvim_feedkeys\bapi\bvim;\0\1\4\0\4\0\0066\1\0\0009\1\1\0019\1\2\0019\3\3\0B\1\2\1K\0\1\0\tbody\20vsnip#anonymous\afn\bvim«\3\0\2\4\2\20\0002-\2\0\0009\3\0\0018\2\3\2=\2\0\0019\2\1\0009\2\2\2\a\2\3\0X\2\6Ä-\2\1\0009\2\4\0029\2\5\2=\2\0\1'\2\a\0=\2\6\0019\2\1\0009\2\2\2\a\2\b\0X\2\6Ä-\2\1\0009\2\t\0029\2\n\2=\2\0\1'\2\v\0=\2\6\0019\2\1\0009\2\2\2\a\2\f\0X\2\6Ä-\2\1\0009\2\t\0029\2\r\2=\2\0\1'\2\14\0=\2\6\0019\2\1\0009\2\2\2\a\2\15\0X\2\6Ä-\2\1\0009\2\t\0029\2\16\2=\2\0\1'\2\17\0=\2\6\0015\2\19\0009\3\1\0009\3\2\0038\2\3\2=\2\18\1L\1\2\0\3¿\2¿\1\0\6\vbuffer\5\nemoji\5\tpath\5\fluasnip\5\rnvim_lua\5\rnvim_lsp\5\tmenu\24CmpItemKindConstant\17CircuitBoard\19lab.quick_data\21CmpItemKindCrate\fPackage\vcrates\21CmpItemKindEmoji\vSmiley\tmisc\nemoji\23CmpItemKindCopilot\18kind_hl_group\rOctoface\bgit\fcopilot\tname\vsource\tkindÂ\1\0\1\5\3\b\1 -\1\0\0009\1\0\1B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\1\1B\1\1\1X\1\22Ä6\1\2\0009\1\3\0019\1\4\1)\3\1\0B\1\2\2\t\1\0\0X\1\5Ä-\1\1\0'\3\5\0'\4\6\0B\1\3\1X\1\nÄ-\1\2\0B\1\1\2\15\0\1\0X\2\4Ä-\1\0\0009\1\a\1B\1\1\1X\1\2Ä\18\1\0\0B\1\1\1K\0\1\0\4¿\1¿\0¿\rcomplete\5!<Plug>(vsnip-expand-or-jump)\20vsnip#available\afn\bvim\21select_next_item\fvisible\2®\1\0\0\4\2\a\1\21-\0\0\0009\0\0\0B\0\1\2\15\0\0\0X\1\4Ä-\0\0\0009\0\1\0B\0\1\1X\0\vÄ6\0\2\0009\0\3\0009\0\4\0)\2ˇˇB\0\2\2\t\0\0\0X\0\4Ä-\0\1\0'\2\5\0'\3\6\0B\0\3\1K\0\1\0\4¿\1¿\5\28<Plug>(vsnip-jump-prev)\19vsnip#jumpable\afn\bvim\21select_prev_item\fvisible\2Ô\t\1\0\15\0G\0ì\0013\0\0\0003\1\1\0006\2\2\0B\2\1\0029\3\3\0026\4\4\0'\6\5\0B\4\2\0029\5\6\0045\a\n\0005\b\b\0003\t\a\0=\t\t\b=\b\v\a5\b\r\0005\t\f\0=\t\14\b3\t\15\0=\t\16\b=\b\17\a5\b\22\0009\t\18\0049\t\19\t9\t\20\t5\v\21\0B\t\2\2=\t\23\b9\t\18\0049\t\19\t9\t\20\t5\v\24\0B\t\2\2=\t\25\b=\b\19\a4\b\6\0005\t\26\0>\t\1\b5\t\27\0>\t\2\b5\t\28\0>\t\3\b5\t\29\0>\t\4\b5\t\30\0>\t\5\b=\b\31\a9\b \0049\b!\b9\b\"\b5\n$\0009\v \0049\v#\vB\v\1\2=\v%\n9\v \0049\v&\vB\v\1\2=\v'\n9\v \0049\v(\vB\v\1\2=\v)\n9\v \0049\v*\vB\v\1\2=\v+\n9\v \0049\v,\v)\r\4\0B\v\2\2=\v-\n9\v \0049\v,\v)\r¸ˇB\v\2\2=\v.\n9\v \0049\v/\v5\r0\0B\v\2\2=\v1\n9\v \0043\r2\0005\0143\0B\v\3\2=\v4\n9\v \0043\r5\0005\0146\0B\v\3\2=\v7\nB\b\2\2=\b \a5\b8\0=\b9\aB\5\2\0019\5\6\0049\5:\5'\a;\0005\b>\0009\t\18\0049\t\31\t4\v\3\0005\f<\0>\f\1\v4\f\3\0005\r=\0>\r\1\fB\t\3\2=\t\31\bB\5\3\0019\5\6\0049\5?\0055\a@\0005\bA\0009\t \0049\t!\t9\t?\tB\t\1\2=\t \b4\t\3\0005\nB\0>\n\1\t=\t\31\bB\5\3\0019\5\6\0049\5?\5'\aC\0005\bD\0009\t \0049\t!\t9\t?\tB\t\1\2=\t \b9\t\18\0049\t\31\t4\v\3\0005\fE\0>\f\1\v4\f\3\0005\rF\0>\r\1\fB\t\3\2=\t\31\bB\5\3\0012\0\0ÄK\0\1\0\1\0\1\tname\fcmdline\1\0\1\tname\tpath\1\0\0\6:\1\0\1\tname\vbuffer\1\0\0\1\3\0\0\6/\6?\fcmdline\1\0\0\1\0\1\tname\vbuffer\1\0\1\tname\fcmp_git\14gitcommit\rfiletype\17experimental\1\0\1\15ghost_text\2\f<S-Tab>\1\3\0\0\6i\6s\0\n<Tab>\1\3\0\0\6i\6s\0\t<CR>\1\0\1\vselect\2\fconfirm\n<C-b>\n<C-f>\16scroll_docs\n<C-e>\nabort\n<C-l>\rcomplete\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\vinsert\vpreset\fmapping\fsources\1\0\2\tname\28nvim_lsp_signature_help\rpriority\3\6\1\0\2\tname\vbuffer\rpriority\3\a\1\0\2\tname\tpath\rpriority\3\b\1\0\2\tname\nvsnip\rpriority\3\t\1\0\2\tname\rnvim_lsp\rpriority\3\n\18documentation\1\0\1\vborder\vdouble\15completion\1\0\0\1\0\1\vborder\vdouble\rbordered\vwindow\vconfig\15formatting\vformat\0\vfields\1\0\0\1\4\0\0\tkind\tabbr\tmenu\fsnippet\1\0\0\vexpand\1\0\0\0\nsetup\bcmp\frequire\tkind\nicons\0\0\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'NvimTreeToggle', function(cmdargs)
          require('packer.load')({'nvim-tree.lua'}, { cmd = 'NvimTreeToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'nvim-tree.lua'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('NvimTreeToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Template', function(cmdargs)
          require('packer.load')({'vim-sonictemplate'}, { cmd = 'Template', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-sonictemplate'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Template ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'OpenInGHRepo', function(cmdargs)
          require('packer.load')({'openingh.nvim'}, { cmd = 'OpenInGHRepo', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'openingh.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('OpenInGHRepo ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'OpenInGHFile', function(cmdargs)
          require('packer.load')({'openingh.nvim'}, { cmd = 'OpenInGHFile', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'openingh.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('OpenInGHFile ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType go ++once lua require("packer.load")({'vim-goaddtags', 'vim-goimpl', 'vim-goimports', 'vim-gomod', 'vim-go-coverage'}, { ft = "go" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'cmp-buffer', 'lexima.vim', 'cmp-calc', 'cmp-nvim-lsp-document-symbol', 'cmp-nvim-lsp-signature-help', 'cmp-path', 'copilot.vim', 'vim-fugitive', 'lspkind.nvim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au ModeChanged * ++once lua require("packer.load")({'cmp-cmdline'}, { event = "ModeChanged *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-gomod/ftdetect/gomod.vim]], true)
vim.cmd [[source /Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-gomod/ftdetect/gomod.vim]]
time([[Sourcing ftdetect script at: /Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-gomod/ftdetect/gomod.vim]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
