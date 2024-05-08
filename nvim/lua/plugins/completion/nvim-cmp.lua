--- lua_source {{{
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

vim.g.use_nerd_icons = false
function icons()
  if vim.fn.has "mac" == 1 or vim.g.use_nerd_icons then
    return {
      kind = {
        -- Text = "",
        Text = "✏︎",
        Method = "m",
        Function = "λ",
        Constructor = "",
        -- Method = "",
        -- Function = "",
        -- Constructor = "",
        Field = "",
        -- Variable = "",
        Variable = "",
        -- Class = "",
        Class = "c",
        Interface = "",
        Module = "",
        -- Module = "",
        Property = "",
        Unit = "",
        -- Value = "",
        Value = "v",
        Enum = "",
        -- Keyword = "",
        Keyword = "",
        Snippet = "",
        -- Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      },
      type = {
        -- Array = "",
        Array = "🗃",
        Number = "",
        -- String = "",
        String = "📖",
        Boolean = "蘒",
        -- Object = "",
        Object = "🗂",
      },
      documents = {
        File = "",
        Files = "",
        Folder = "",
        OpenFolder = "",
      },
      git = {
        Add = "",
        Mod = "",
        Remove = "",
        Ignore = "",
        Rename = "",
        Diff = "",
        Repo = "",
        Octoface = "",
      },
      ui = {
        ArrowClosed = "",
        ArrowOpen = "",
        Lock = "",
        Circle = "",
        BigCircle = "",
        BigUnfilledCircle = "",
        Close = "",
        NewFile = "",
        Search = "",
        Lightbulb = "",
        Project = "",
        Dashboard = "",
        History = "",
        Comment = "",
        Bug = "",
        Code = "",
        Telescope = "",
        Gear = "",
        Package = "",
        List = "",
        SignIn = "",
        SignOut = "",
        Check = "",
        Fire = "",
        Note = "",
        BookMark = "",
        Pencil = "",
        -- ChevronRight = "",
        ChevronRight = ">",
        Table = "",
        Calendar = "",
        CloudDownload = "",
      },
      diagnostics = {
        Error = "",
        Warning = "",
        Information = "",
        Question = "",
        Hint = "",
      },
      misc = {
        Robot = "ﮧ",
        Squirrel = "",
        Tag = "",
        Watch = "",
        Smiley = "ﲃ",
        Package = "",
        CircuitBoard = "",
      },
    }
  else
    return {
      kind = {
        Text = " ",
        Method = " ",
        Function = " ",
        Constructor = " ",
        Field = " ",
        Variable = " ",
        Class = " ",
        Interface = " ",
        Module = " ",
        Property = " ",
        Unit = " ",
        Value = " ",
        Enum = " ",
        Keyword = " ",
        Snippet = " ",
        Color = " ",
        File = " ",
        Reference = " ",
        Folder = " ",
        EnumMember = " ",
        Constant = " ",
        Struct = " ",
        Event = " ",
        Operator = " ",
        TypeParameter = " ",
        Misc = " ",
      },
      type = {
        Array = " ",
        Number = " ",
        String = " ",
        Boolean = " ",
        Object = " ",
      },
      documents = {
        File = " ",
        Files = " ",
        Folder = " ",
        OpenFolder = " ",
      },
      git = {
        Add = " ",
        Mod = " ",
        Remove = " ",
        Ignore = " ",
        Rename = " ",
        Diff = " ",
        Repo = " ",
        Octoface = " ",
      },
      ui = {
        ArrowClosed = "",
        ArrowOpen = "",
        Lock = " ",
        Circle = " ",
        BigCircle = " ",
        BigUnfilledCircle = " ",
        Close = " ",
        NewFile = " ",
        Search = " ",
        Lightbulb = " ",
        Project = " ",
        Dashboard = " ",
        History = " ",
        Comment = " ",
        Bug = " ",
        Code = " ",
        Telescope = " ",
        Gear = " ",
        Package = " ",
        List = " ",
        SignIn = " ",
        SignOut = " ",
        NoteBook = " ",
        Check = " ",
        Fire = " ",
        Note = " ",
        BookMark = " ",
        Pencil = " ",
        ChevronRight = "",
        Table = " ",
        Calendar = " ",
        CloudDownload = " ",
      },
      diagnostics = {
        Error = " ",
        Warning = " ",
        Information = " ",
        Question = " ",
        Hint = " ",
      },
      misc = {
        Robot = " ",
        Squirrel = " ",
        Tag = " ",
        Watch = " ",
        Smiley = " ",
        Package = " ",
        CircuitBoard = " ",
      },
    }
  end
end

local icn = icons()
local kind_icons = icn.kind

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = kind_icons[vim_item.kind]

      if entry.source.name == "copilot" then
        vim_item.kind = icn.git.Octoface
        vim_item.kind_hl_group = "CmpItemKindCopilot"
      end

      if entry.source.name == "emoji" then
        vim_item.kind = icn.misc.Smiley
        vim_item.kind_hl_group = "CmpItemKindEmoji"
      end

      if entry.source.name == "crates" then
        vim_item.kind = icn.misc.Package
        vim_item.kind_hl_group = "CmpItemKindCrate"
      end

      if entry.source.name == "lab.quick_data" then
        vim_item.kind = icn.misc.CircuitBoard
        vim_item.kind_hl_group = "CmpItemKindConstant"
      end

      -- NOTE: order matters
      vim_item.menu = ({
        nvim_lsp = "",
        nvim_lua = "",
        luasnip = "",
        buffer = "",
        path = "",
        emoji = "",
      })[entry.source.name]
      return vim_item
    end,
  },
  window = {
    completion = cmp.config.window.bordered({
      border = 'double'
    }),
    documentation = cmp.config.window.bordered({
      border = 'double'
    }),
  },
  sources = {
    { name = "nvim_lsp",                priority = 10 },
    { name = 'vsnip',                   priority = 9 },
    { name = "path",                    priority = 8 },
    { name = "buffer",                  priority = 7 },
    { name = "nvim_lsp_signature_help", priority = 6 },
    { name = "emoji",                   priority = 1 },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  experimental = {
    ghost_text = true,
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
--- }}}
