return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 20,
      open_mapping = [[<C-\>]],
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      persist_size = false,
      direction = 'float',
      close_on_exit = true, -- close the terminal window when the process exits
      shell = nil, -- change the default shell
      float_opts = {
        border = 'rounded',
        winblend = 18,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      winbar = {
        enabled = true,
        name_formatter = function(term) --  term: Terminal
          return term.count
        end,
      },
    }

    -- Toggle terminal with Ctrl + ` (VS Code default) or Ctrl + j
    local function toggle_term()
      require('toggleterm').toggle(0)
    end

    vim.keymap.set('n', '<C-j>', toggle_term, { noremap = true, silent = true, desc = 'Toggle Terminal' })
    vim.keymap.set('n', '<C-`>', toggle_term, { noremap = true, silent = true, desc = 'Toggle Terminal' })
    vim.keymap.set('i', '<C-j>', '<Esc><cmd>lua require("toggleterm").toggle(0)<CR>', { noremap = true, silent = true, desc = 'Toggle Terminal' })
    vim.keymap.set('i', '<C-`>', '<Esc><cmd>lua require("toggleterm").toggle(0)<CR>', { noremap = true, silent = true, desc = 'Toggle Terminal' })
    vim.keymap.set('t', '<C-j>', [[<C-\><C-n><cmd>lua require("toggleterm").toggle(0)<CR>]], { noremap = true, silent = true, desc = 'Toggle Terminal' })
    vim.keymap.set('t', '<C-`>', [[<C-\><C-n><cmd>lua require("toggleterm").toggle(0)<CR>]], { noremap = true, silent = true, desc = 'Toggle Terminal' })

    vim.cmd [[
        augroup terminal_setup | au!
        autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i
        autocmd TermEnter * startinsert!
        augroup end
        ]]

    vim.api.nvim_create_autocmd({ 'TermEnter' }, {
      pattern = { '*' },
      callback = function()
        vim.cmd 'startinsert'
        _G.set_terminal_keymaps()
      end,
    })

    local opts = { noremap = true, silent = true }
    function _G.set_terminal_keymaps()
      vim.api.nvim_buf_set_keymap(0, 't', '<m-h>', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<m-j>', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<m-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<m-l>', [[<C-\><C-n><C-W>l]], opts)
    end
  end,
}
