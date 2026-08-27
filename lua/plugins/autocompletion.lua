return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  -- event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      -- follow latest release.
      version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = 'make install_jsregexp',
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    -- Load friendly-snippets & custom VS Code snippets from ~/.config/nvim/snippets
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }

    -- Extend filetypes so React and HTML snippets work across JS/TS/JSX/TSX files
    luasnip.filetype_extend('javascript', { 'javascriptreact', 'html' })
    luasnip.filetype_extend('typescript', { 'typescriptreact', 'html' })
    luasnip.filetype_extend('javascriptreact', { 'html' })
    luasnip.filetype_extend('typescriptreact', { 'html' })
    luasnip.filetype_extend('cpp', { 'c' })

    local kind_icons = {
      Text = '󰉿',
      Method = 'm',
      Function = '󰊕',
      Constructor = '',
      Field = '',
      Variable = '󰆧',
      Class = '󰌗',
      Interface = '',
      Module = '',
      Property = '',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰇽',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰊄',
    }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      preselect = cmp.PreselectMode.None,
      completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 1,
      },
      -- window = {
      --     completion = cmp.config.window.bordered(),
      --     documentation = cmp.config.window.bordered(),
      -- },
      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
        ['<C-k>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept the completion with Enter.
        ['<C-c>'] = cmp.mapping.complete {}, -- Manually trigger a completion from nvim-cmp.
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- Select next/previous item with Tab / Shift + Tab
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      experimental = {
        ghost_text = true,
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format('%s', kind_icons[vim_item.kind])
          -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            nvim_lua = '[Lua]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
  end,
}
