return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'mxsdev/nvim-dap-vscode-js',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      ensure_installed = { 'js' },
      automatic_installation = true,
      handlers = {},
    }

    require('nvim-dap-virtual-text').setup {}

    dapui.setup {}

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter'
    require('dap-vscode-js').setup {
      debugger_path = mason_path,
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    }

    for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-chrome',
          request = 'launch',
          name = 'Launch Chrome',
          url = 'http://localhost:3000',
          webRoot = '${workspaceFolder}',
        },
      }
    end

    vim.keymap.set('n', '<F5>', function()
      dap.continue()
    end, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F10>', function()
      dap.step_over()
    end, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F11>', function()
      dap.step_into()
    end, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F12>', function()
      dap.step_out()
    end, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>db', function()
      dap.toggle_breakpoint()
    end, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>dB', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Conditional Breakpoint' })
    vim.keymap.set('n', '<leader>du', function()
      dapui.toggle {}
    end, { desc = 'Debug: Toggle UI' })
  end,
}
