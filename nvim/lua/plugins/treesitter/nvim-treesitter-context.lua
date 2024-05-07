--- lua_source {{{
vim.cmd("hi TreesitterContextBottom gui=underline guisp=Grey")
require 'treesitter-context'.setup {
  patterns = {
    default = {
      'class',
      'function',
      'method',
      'interface',
      'struct',
    },
    haskell = {
      'adt'
    },
    rust = {
      'impl_item',

    },
    terraform = {
      'block',
      'object_elem',
      'attribute',
    },
    markdown = {
      'section',
    },
    json = {
      'pair',
    },
    typescript = {
      'export_statement',
    },
    yaml = {
      'block_mapping_pair',
    },
  },
}
--- }}}
