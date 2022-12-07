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
  ["context_filetype.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/context_filetype.vim",
    url = "https://github.com/Shougo/context_filetype.vim"
  },
  ["ddc-around"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-around",
    url = "https://github.com/Shougo/ddc-around"
  },
  ["ddc-converter_remove_overlap"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-converter_remove_overlap",
    url = "https://github.com/Shougo/ddc-converter_remove_overlap"
  },
  ["ddc-file"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-file",
    url = "https://github.com/LumaKernel/ddc-file"
  },
  ["ddc-matcher_head"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-matcher_head",
    url = "https://github.com/Shougo/ddc-matcher_head"
  },
  ["ddc-nvim-lsp"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-nvim-lsp",
    url = "https://github.com/Shougo/ddc-nvim-lsp"
  },
  ["ddc-sorter_rank"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-sorter_rank",
    url = "https://github.com/Shougo/ddc-sorter_rank"
  },
  ["ddc-ui-native"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/ddc-ui-native",
    url = "https://github.com/Shougo/ddc-ui-native"
  },
  ["ddc.vim"] = {
    config = { "\27LJ\2\n“\16\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0≤\16        call ddc#custom#patch_global(\"ui\", \"native\")\n        call ddc#custom#patch_global(\"sources\", [\n            \\ \"around\",\n            \\ \"file\",\n            \\ \"vsnip\",\n            \\ \"nvim-lsp\"\n            \\ ])\n        call ddc#custom#patch_global(\"sourceOptions\", {\n            \\ \"_\": {\n            \\   \"matchers\": [\"matcher_head\"],\n            \\   \"sorters\": [\"sorter_rank\"],\n            \\   \"converters\": [\"converter_remove_overlap\"],\n            \\ },\n            \\ \"around\": {\"mark\": \"Around\"},\n            \\ \"file\": {\n            \\   \"mark\": \"file\",\n            \\   \"isVolatile\": v:true,\n            \\   \"forceCompletionPattern\": \"\\S/\\S*\",\n            \\ },\n            \\ \"vsnip\": {\n            \\   \"mark\": \"vsnip\",\n            \\   \"minAutoCompleteLength\": 1,\n            \\ },\n            \\ \"nvim-lsp\": {\n            \\   \"mark\": \"LSP\",\n            \\   \"forceCompletionPattern\": \"\\.\\w*|:\\w*|->\\w*\",\n            \\ },\n            \\ })\n        \n        call ddc#custom#patch_global(\"sourceParams\", {\n           \\ \"around\": {\"maxSize\": 500},\n           \\ })\n        \n        \" Use Customized labels\n        call ddc#custom#patch_global(\"sourceParams\", {\n           \\ \"nvim-lsp\": { \"kindLabels\": { \"Class\": \"c\" } },\n           \\ })\n        \n        \" pum.vim setting\n        call ddc#custom#patch_global(\"completionMenu\", \"pum.vim\")\n        inoremap <silent><expr> <TAB>\n        \\ pumvisible() ? \"<C-n>\" :\n        \\ (col(\".\") <= 1 <Bar><Bar> getline(\".\")[col(\".\") - 2] =~# \"\\s\") ?\n        \\ \"<TAB>\" : ddc#map#manual_complete()\n        \n        \" <S-TAB>: completion back.\n        inoremap <expr><S-TAB>  pumvisible() ? \"<C-p>\" : \"<C-h>\"\n        \n        inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>\n        inoremap <C-n>   <Cmd>call pum#map#select_relative(+1)<CR>\n        inoremap <C-p>   <Cmd>call pum#map#select_relative(-1)<CR>\n        inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>\n        inoremap <C-e> <Cmd>call pum#map#cancel()<CR>\n        \n        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n        call ddc#enable()\n      \bcmd\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/ddc.vim",
    url = "https://github.com/Shougo/ddc.vim"
  },
  ["denops-popup-preview.vim"] = {
    config = { "\27LJ\2\n7\0\0\2\0\3\0\0056\0\0\0009\0\1\0009\0\2\0B\0\1\1K\0\1\0\25popup_preview#enable\afn\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/denops-popup-preview.vim",
    url = "https://github.com/matsui54/denops-popup-preview.vim"
  },
  ["denops-signature_help"] = {
    config = { "\27LJ\2\n8\0\0\2\0\3\0\0056\0\0\0009\0\1\0009\0\2\0B\0\1\1K\0\1\0\26signature_help#enable\afn\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/denops-signature_help",
    url = "https://github.com/matsui54/denops-signature_help"
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
  ["gruvbox-baby"] = {
    config = { "\27LJ\2\n™\1\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ä\1        colorscheme gruvbox-baby\n        \" Ê§úÁ¥¢ÊôÇ„ÅÆ„Éè„Ç§„É©„Ç§„Éà„ÅÆËâ≤„ÇíÂ§âÊõ¥\n        hi Search guibg=peru guifg=wheat\n      \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/gruvbox-baby",
    url = "https://github.com/luisiacc/gruvbox-baby"
  },
  ["impatient.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\3\0\t6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\19enable_profile\14impatient\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lexima.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/lexima.vim",
    url = "https://github.com/cohama/lexima.vim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_option\bapi\bvim†\n\1\2\v\0&\0k3\2\0\0003\3\1\0005\4\2\0\18\5\2\0'\a\3\0'\b\4\0'\t\5\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\6\0'\t\a\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\b\0'\t\t\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\n\0'\t\v\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\f\0'\t\r\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\14\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\16\0'\t\17\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\18\0'\t\19\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\20\0'\t\21\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\22\0'\t\23\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\24\0'\t\25\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\26\0'\t\27\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\28\0'\t\29\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\30\0'\t\31\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b \0'\t!\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\"\0'\t#\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b$\0'\t%\0\18\n\4\0B\5\5\0012\0\0ÄK\0\1\0&<cmd>lua vim.lsp.buf.format()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<cmd>lua vim.lsp.buf.hover()<CR>\6K*<cmd>lua vim.lsp.buf.definition()<CR>\agd+<cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\1\0\2\vsilent\2\fnoremap\2\0\0¬\1\0\1\a\2\n\0\24\a\0\0\0X\1\14Ä-\1\0\0008\1\0\0019\1\1\0015\3\2\0-\4\1\0=\4\3\0035\4\a\0005\5\5\0005\6\4\0=\6\6\5=\5\0\4=\4\b\3B\1\2\1X\1\aÄ-\1\0\0008\1\0\0019\1\1\0015\3\t\0-\4\1\0=\4\3\3B\1\2\1K\0\1\0\2¿\0¿\1\0\0\rsettings\1\0\0\benv\1\0\0\1\0\1\fGOFLAGS!-tags=integration,wireinject\14on_attach\1\0\0\nsetup\ngoplsì\3\0\1\17\0\18\00046\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\6\0005\3\5\0=\3\a\2=\2\4\0016\2\0\0009\2\1\0029\2\b\2)\4\0\0'\5\t\0\18\6\1\0\18\a\0\0B\2\5\0026\3\n\0\f\5\2\0X\5\1Ä4\5\0\0B\3\2\4H\6\26Ä6\b\n\0009\n\v\a\14\0\n\0X\v\1Ä4\n\0\0B\b\2\4H\v\17Ä9\r\f\f\15\0\r\0X\14\bÄ6\r\0\0009\r\1\r9\r\2\r9\r\r\r9\15\f\f'\16\14\0B\r\3\1X\r\6Ä6\r\0\0009\r\1\r9\r\15\r9\r\16\r9\15\17\fB\r\2\1F\v\3\3R\vÌ\127F\6\3\3R\6‰\127K\0\1\0\fcommand\20execute_command\bbuf\nUTF-8\25apply_workspace_edit\tedit\vresult\npairs\28textDocument/codeAction\21buf_request_sync\tonly\1\0\0\1\2\0\0\27source.organizeImports\fcontext\22make_range_params\tutil\blsp\bvim¢\4\1\0\b\0\25\0-3\0\0\0006\1\1\0009\1\2\0019\1\3\0019\1\4\1B\1\1\0029\2\5\0019\2\6\0029\2\a\2+\3\2\0=\3\b\0026\2\t\0'\4\n\0B\2\2\0026\3\t\0'\5\v\0B\3\2\0029\3\f\0035\5\16\0005\6\14\0005\a\r\0=\a\15\6=\6\17\5B\3\2\0016\3\t\0'\5\18\0B\3\2\0029\3\f\3B\3\1\0016\3\t\0'\5\18\0B\3\2\0029\3\19\0034\5\3\0003\6\20\0>\6\1\5B\3\2\0013\3\21\0007\3\22\0006\3\1\0009\3\23\3'\5\24\0B\3\2\0012\0\0ÄK\0\1\0h        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n      \bcmd\15OrgImports\0\0\19setup_handlers\20mason-lspconfig\aui\1\0\0\nicons\1\0\0\1\0\3\22package_installed\b‚úì\24package_uninstalled\b‚úó\20package_pending\b‚ûú\nsetup\nmason\14lspconfig\frequire\19snippetSupport\19completionItem\15completion\17textDocument\29make_client_capabilities\rprotocol\blsp\bvim\0\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fÌ\2\1\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0003\4\a\0=\4\b\3=\3\t\0025\3\n\0=\3\v\2B\0\2\0016\0\f\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0008hi TreesitterContextBottom gui=underline guisp=Grey\bcmd\bvim\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2\venable\2&additional_vim_regex_highlighting\1\21ensure_installed\1\0\2\17auto_install\2\17sync_install\1\1\n\0\0\blua\ago\vpython\tbash\15typescript\tyaml\ttoml\tjson\bvim\nsetup\28nvim-treesitter.configs\frequire\0" },
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
  ["pum.vim"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/pum.vim",
    url = "https://github.com/Shougo/pum.vim"
  },
  ["quick-scope"] = {
    config = { "\27LJ\2\nŸ\2\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0π\2        augroup qs_colors\n          autocmd!\n          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline\n          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline\n        augroup END\n      \bcmd\bvim\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/quick-scope",
    url = "https://github.com/unblevable/quick-scope"
  },
  ["spelunker.vim"] = {
    after_files = { "/Users/s11591/.local/share/nvim/site/pack/packer/opt/spelunker.vim/after/plugin/ctrlp/spelunker.vim" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/spelunker.vim",
    url = "https://github.com/kamykn/spelunker.vim"
  },
  ["telescope-env.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\benv\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/telescope-env.nvim",
    url = "https://github.com/LinArcX/telescope-env.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\19live_grep_args\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n¸\1\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\3=\3\v\2B\0\2\1K\0\1\0\15extensions\1\0\0\19live_grep_args\1\0\1\17auto_quoting\2\17file_browser\1\0\1\17hijack_netrw\2\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\nsetup\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
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
  ["vim-floaterm"] = {
    commands = { "FloatermToggle" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/vim-floaterm",
    url = "https://github.com/voldikss/vim-floaterm"
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
    config = { "\27LJ\2\nì\r\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0Û\f        let g:vsnip_snippet_dir = \"$HOME/.vim/vsnip\"\n        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n        \n        \"function s:trigger_completedone()\n        \"  let info = pum#complete_info()\n        \"  let complete_item = info.items[info.selected]\n        \"  call vsnip_integ#on_complete_done(complete_item)\n        \"  if vsnip#available(1)\n        \"    return \"\\<Plug>(vsnip-expand-or-jump)\"\n        \"  else\n        \"    return \"\\<Tab>\"\n        \"  \"return \"\\<Ignore>\"\n        \"endfunction\n        \"\n        \"imap <expr> <Tab> <SID>trigger_completedone()\n        \"smap <expr> <Tab> <SID>trigger_completedone()\n        \" imap <expr> <Tab>   vsnip#available(1)  ? \"<Plug>(vsnip-expand-or-jump)\" : \"<Tab>\"\n        \" smap <expr> <Tab>   vsnip#available(1)  ? \"<Plug>(vsnip-expand-or-jump)\" : \"<Tab>\"\n        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        \n        imap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        smap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        imap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        smap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        imap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        smap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        let g:vsnip_filetypes = {}\n        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)\n        \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/vim-vsnip",
    url = "https://github.com/hrsh7th/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = true,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/start/vim-vsnip-integ",
    url = "https://github.com/hrsh7th/vim-vsnip-integ"
  },
  winresizer = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/s11591/.local/share/nvim/site/pack/packer/opt/winresizer",
    url = "https://github.com/simeji/winresizer"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: spelunker.vim
time([[Setup for spelunker.vim]], true)
try_loadstring("\27LJ\2\n[\0\0\2\0\4\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\2\0=\1\3\0K\0\1\0\25spelunker_check_type\25enable_spelunker_vim\6g\bvim\0", "setup", "spelunker.vim")
time([[Setup for spelunker.vim]], false)
time([[packadd for spelunker.vim]], true)
vim.cmd [[packadd spelunker.vim]]
time([[packadd for spelunker.vim]], false)
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
-- Setup for: vim-goimports
time([[Setup for vim-goimports]], true)
try_loadstring("\27LJ\2\n+\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\14goimports\6g\bvim\0", "setup", "vim-goimports")
time([[Setup for vim-goimports]], false)
-- Setup for: vim-floaterm
time([[Setup for vim-floaterm]], true)
try_loadstring("\27LJ\2\nX\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\tüêº\19floaterm_title\23floaterm_autoclose\6g\bvim\0", "setup", "vim-floaterm")
time([[Setup for vim-floaterm]], false)
-- Config for: gruvbox-baby
time([[Config for gruvbox-baby]], true)
try_loadstring("\27LJ\2\n™\1\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0ä\1        colorscheme gruvbox-baby\n        \" Ê§úÁ¥¢ÊôÇ„ÅÆ„Éè„Ç§„É©„Ç§„Éà„ÅÆËâ≤„ÇíÂ§âÊõ¥\n        hi Search guibg=peru guifg=wheat\n      \bcmd\bvim\0", "config", "gruvbox-baby")
time([[Config for gruvbox-baby]], false)
-- Config for: telescope-file-browser.nvim
time([[Config for telescope-file-browser.nvim]], true)
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0", "config", "telescope-file-browser.nvim")
time([[Config for telescope-file-browser.nvim]], false)
-- Config for: denops-popup-preview.vim
time([[Config for denops-popup-preview.vim]], true)
try_loadstring("\27LJ\2\n7\0\0\2\0\3\0\0056\0\0\0009\0\1\0009\0\2\0B\0\1\1K\0\1\0\25popup_preview#enable\afn\bvim\0", "config", "denops-popup-preview.vim")
time([[Config for denops-popup-preview.vim]], false)
-- Config for: quick-scope
time([[Config for quick-scope]], true)
try_loadstring("\27LJ\2\nŸ\2\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0π\2        augroup qs_colors\n          autocmd!\n          autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline\n          autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline\n        augroup END\n      \bcmd\bvim\0", "config", "quick-scope")
time([[Config for quick-scope]], false)
-- Config for: telescope-fzf-native.nvim
time([[Config for telescope-fzf-native.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")
time([[Config for telescope-fzf-native.nvim]], false)
-- Config for: denops-signature_help
time([[Config for denops-signature_help]], true)
try_loadstring("\27LJ\2\n8\0\0\2\0\3\0\0056\0\0\0009\0\1\0009\0\2\0B\0\1\1K\0\1\0\26signature_help#enable\afn\bvim\0", "config", "denops-signature_help")
time([[Config for denops-signature_help]], false)
-- Config for: vim-vsnip
time([[Config for vim-vsnip]], true)
try_loadstring("\27LJ\2\nì\r\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0Û\f        let g:vsnip_snippet_dir = \"$HOME/.vim/vsnip\"\n        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n        \n        \"function s:trigger_completedone()\n        \"  let info = pum#complete_info()\n        \"  let complete_item = info.items[info.selected]\n        \"  call vsnip_integ#on_complete_done(complete_item)\n        \"  if vsnip#available(1)\n        \"    return \"\\<Plug>(vsnip-expand-or-jump)\"\n        \"  else\n        \"    return \"\\<Tab>\"\n        \"  \"return \"\\<Ignore>\"\n        \"endfunction\n        \"\n        \"imap <expr> <Tab> <SID>trigger_completedone()\n        \"smap <expr> <Tab> <SID>trigger_completedone()\n        \" imap <expr> <Tab>   vsnip#available(1)  ? \"<Plug>(vsnip-expand-or-jump)\" : \"<Tab>\"\n        \" smap <expr> <Tab>   vsnip#available(1)  ? \"<Plug>(vsnip-expand-or-jump)\" : \"<Tab>\"\n        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? \"<Plug>(vsnip-jump-prev)\"      : \"<S-Tab>\"\n        \n        imap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        smap <expr> <C-j> vsnip#expandable() ? \"<Plug>(vsnip-expand)\" : \"<C-j>\"\n        imap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        smap <expr> <C-f> vsnip#jumpable(1)  ? \"<Plug>(vsnip-jump-next)\" : \"<C-f>\"\n        imap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        smap <expr> <C-b> vsnip#jumpable(-1) ? \"<Plug>(vsnip-jump-prev)\" : \"<C-b>\"\n        let g:vsnip_filetypes = {}\n        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)\n        \bcmd\bvim\0", "config", "vim-vsnip")
time([[Config for vim-vsnip]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\n˙\2\0\0\5\0\22\0\0256\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\20\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\0035\4\n\0=\4\v\0035\4\f\0=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3=\3\21\2B\0\2\1K\0\1\0\rpatterns\1\0\0\tyaml\1\2\0\0\23block_mapping_pair\15typescript\1\2\0\0\21export_statement\tjson\1\2\0\0\tpair\rmarkdown\1\2\0\0\fsection\14terraform\1\4\0\0\nblock\16object_elem\14attribute\trust\1\2\0\0\14impl_item\fhaskell\1\2\0\0\badt\fdefault\1\0\0\1\6\0\0\nclass\rfunction\vmethod\14interface\vstruct\nsetup\23treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n¸\1\0\0\5\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\0035\4\b\0=\4\t\3=\3\v\2B\0\2\1K\0\1\0\15extensions\1\0\0\19live_grep_args\1\0\1\17auto_quoting\2\17file_browser\1\0\1\17hijack_netrw\2\bfzf\1\0\0\1\0\4\28override_generic_sorter\2\nfuzzy\2\14case_mode\15smart_case\25override_file_sorter\2\nsetup\14telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: impatient.nvim
time([[Config for impatient.nvim]], true)
try_loadstring("\27LJ\2\nL\0\0\3\0\3\0\t6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\19enable_profile\14impatient\frequire\0", "config", "impatient.nvim")
time([[Config for impatient.nvim]], false)
-- Config for: telescope-live-grep-args.nvim
time([[Config for telescope-live-grep-args.nvim]], true)
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\19live_grep_args\19load_extension\14telescope\frequire\0", "config", "telescope-live-grep-args.nvim")
time([[Config for telescope-live-grep-args.nvim]], false)
-- Config for: telescope-env.nvim
time([[Config for telescope-env.nvim]], true)
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\benv\19load_extension\14telescope\frequire\0", "config", "telescope-env.nvim")
time([[Config for telescope-env.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\nA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_keymap\bapi\bvimA\2\0\4\1\3\0\a6\0\0\0009\0\1\0009\0\2\0-\2\0\0G\3\0\0A\0\1\1K\0\1\0\1¿\24nvim_buf_set_option\bapi\bvim†\n\1\2\v\0&\0k3\2\0\0003\3\1\0005\4\2\0\18\5\2\0'\a\3\0'\b\4\0'\t\5\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\6\0'\t\a\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\b\0'\t\t\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\n\0'\t\v\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\f\0'\t\r\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\14\0'\t\15\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\16\0'\t\17\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\18\0'\t\19\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\20\0'\t\21\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\22\0'\t\23\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\24\0'\t\25\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\26\0'\t\27\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\28\0'\t\29\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\30\0'\t\31\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b \0'\t!\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b\"\0'\t#\0\18\n\4\0B\5\5\1\18\5\2\0'\a\3\0'\b$\0'\t%\0\18\n\4\0B\5\5\0012\0\0ÄK\0\1\0&<cmd>lua vim.lsp.buf.format()<CR>\r<space>f2<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>\r<space>q0<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d0<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d<<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>\r<space>e*<cmd>lua vim.lsp.buf.references()<CR>\agr+<cmd>lua vim.lsp.buf.code_action()<CR>\14<space>ca&<cmd>lua vim.lsp.buf.rename()<CR>\14<space>rn/<cmd>lua vim.lsp.buf.type_definition()<CR>\r<space>DJ<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>\14<space>wl7<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>\14<space>wr4<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>\14<space>wa.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>.<cmd>lua vim.lsp.buf.implementation()<CR>\agi%<cmd>lua vim.lsp.buf.hover()<CR>\6K*<cmd>lua vim.lsp.buf.definition()<CR>\agd+<cmd>lua vim.lsp.buf.declaration()<CR>\agD\6n\1\0\2\vsilent\2\fnoremap\2\0\0¬\1\0\1\a\2\n\0\24\a\0\0\0X\1\14Ä-\1\0\0008\1\0\0019\1\1\0015\3\2\0-\4\1\0=\4\3\0035\4\a\0005\5\5\0005\6\4\0=\6\6\5=\5\0\4=\4\b\3B\1\2\1X\1\aÄ-\1\0\0008\1\0\0019\1\1\0015\3\t\0-\4\1\0=\4\3\3B\1\2\1K\0\1\0\2¿\0¿\1\0\0\rsettings\1\0\0\benv\1\0\0\1\0\1\fGOFLAGS!-tags=integration,wireinject\14on_attach\1\0\0\nsetup\ngoplsì\3\0\1\17\0\18\00046\1\0\0009\1\1\0019\1\2\0019\1\3\1B\1\1\0025\2\6\0005\3\5\0=\3\a\2=\2\4\0016\2\0\0009\2\1\0029\2\b\2)\4\0\0'\5\t\0\18\6\1\0\18\a\0\0B\2\5\0026\3\n\0\f\5\2\0X\5\1Ä4\5\0\0B\3\2\4H\6\26Ä6\b\n\0009\n\v\a\14\0\n\0X\v\1Ä4\n\0\0B\b\2\4H\v\17Ä9\r\f\f\15\0\r\0X\14\bÄ6\r\0\0009\r\1\r9\r\2\r9\r\r\r9\15\f\f'\16\14\0B\r\3\1X\r\6Ä6\r\0\0009\r\1\r9\r\15\r9\r\16\r9\15\17\fB\r\2\1F\v\3\3R\vÌ\127F\6\3\3R\6‰\127K\0\1\0\fcommand\20execute_command\bbuf\nUTF-8\25apply_workspace_edit\tedit\vresult\npairs\28textDocument/codeAction\21buf_request_sync\tonly\1\0\0\1\2\0\0\27source.organizeImports\fcontext\22make_range_params\tutil\blsp\bvim¢\4\1\0\b\0\25\0-3\0\0\0006\1\1\0009\1\2\0019\1\3\0019\1\4\1B\1\1\0029\2\5\0019\2\6\0029\2\a\2+\3\2\0=\3\b\0026\2\t\0'\4\n\0B\2\2\0026\3\t\0'\5\v\0B\3\2\0029\3\f\0035\5\16\0005\6\14\0005\a\r\0=\a\15\6=\6\17\5B\3\2\0016\3\t\0'\5\18\0B\3\2\0029\3\f\3B\3\1\0016\3\t\0'\5\18\0B\3\2\0029\3\19\0034\5\3\0003\6\20\0>\6\1\5B\3\2\0013\3\21\0007\3\22\0006\3\1\0009\3\23\3'\5\24\0B\3\2\0012\0\0ÄK\0\1\0h        autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)\n      \bcmd\15OrgImports\0\0\19setup_handlers\20mason-lspconfig\aui\1\0\0\nicons\1\0\0\1\0\3\22package_installed\b‚úì\24package_uninstalled\b‚úó\20package_pending\b‚ûú\nsetup\nmason\14lspconfig\frequire\19snippetSupport\19completionItem\15completion\17textDocument\29make_client_capabilities\rprotocol\blsp\bvim\0\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\nê\1\0\2\t\0\a\1\21*\2\0\0006\3\0\0006\5\1\0009\5\2\0059\5\3\0056\6\1\0009\6\4\0069\6\5\6\18\b\1\0B\6\2\0A\3\1\3\15\0\3\0X\5\aÄ\15\0\4\0X\5\5Ä9\5\6\4\1\2\5\0X\5\2Ä+\5\2\0L\5\2\0K\0\1\0\tsize\22nvim_buf_get_name\bapi\ffs_stat\tloop\bvim\npcallÄ¿\fÌ\2\1\0\5\0\15\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0003\4\a\0=\4\b\3=\3\t\0025\3\n\0=\3\v\2B\0\2\0016\0\f\0009\0\r\0'\2\14\0B\0\2\1K\0\1\0008hi TreesitterContextBottom gui=underline guisp=Grey\bcmd\bvim\vindent\1\0\1\venable\2\14highlight\fdisable\0\1\0\2\venable\2&additional_vim_regex_highlighting\1\21ensure_installed\1\0\2\17auto_install\2\17sync_install\1\1\n\0\0\blua\ago\vpython\tbash\15typescript\tyaml\ttoml\tjson\bvim\nsetup\28nvim-treesitter.configs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Template', function(cmdargs)
          require('packer.load')({'vim-sonictemplate'}, { cmd = 'Template', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-sonictemplate'}, { cmd = 'Template' }, _G.packer_plugins)
          return vim.fn.getcompletion('Template ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'FloatermToggle', function(cmdargs)
          require('packer.load')({'vim-floaterm'}, { cmd = 'FloatermToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-floaterm'}, { cmd = 'FloatermToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('FloatermToggle ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType go ++once lua require("packer.load")({'vim-go-coverage', 'vim-gomod', 'vim-goimports', 'vim-goaddtags', 'vim-goimpl'}, { ft = "go" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au CursorHold * ++once lua require("packer.load")({'ddc.vim'}, { event = "CursorHold *" }, _G.packer_plugins)]]
vim.cmd [[au CmdlineEnter * ++once lua require("packer.load")({'ddc.vim'}, { event = "CmdlineEnter *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'ddc.vim'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
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
