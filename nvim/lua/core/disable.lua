local global_options = {
  loaded_2html_plugin       = true,
  loaded_gzip               = true,
  loaded_tar                = true,
  loaded_tarPlugin          = true,
  loaded_zip                = true,
  loaded_zipPlugin          = true,
  loaded_vimball            = true,
  loaded_vimballPlugin      = true,
  loaded_netrw              = true,
  loaded_netrwPlugin        = true,
  loaded_netrwSettings      = true,
  loaded_netrwFileHandlers  = true,
  loaded_getscript          = true,
  loaded_getscriptPlugin    = true,
  loaded_man                = true,
  loaded_matchit            = true,
  loaded_matchparen         = true,
  loaded_shada_plugin       = true,
  loaded_spellfile_plugin   = true,
  loaded_tutor_mode_plugin  = true,
  did_install_default_menus = true,
  did_install_syntax_menu   = true,
  skip_loading_mswin        = true,
  did_indent_on             = true,
  did_load_ftplugin         = true,
  loaded_rrhelper           = true,
}

for k, v in pairs(global_options) do
  vim.g[k] = v
end
