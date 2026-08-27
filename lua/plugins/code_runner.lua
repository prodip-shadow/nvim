return {
  'CRAG666/code_runner.nvim',
  config = function()
    require('code_runner').setup {
      mode = 'toggleterm',
      filetype = {
        java = {
          'cd $dir &&',
          'javac $fileName &&',
          'java $fileNameWithoutExt',
        },
        python = 'python3 -u',
        javascript = 'node',
        typescript = 'ts-node',
        c = {
          'cd $dir &&',
          'gcc $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
        cpp = {
          'cd $dir &&',
          'g++ $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
      },
    }

    vim.keymap.set('n', '<C-M-n>', ':RunCode<CR>', { noremap = true, silent = false, desc = 'Run Code' })
    vim.keymap.set('i', '<C-M-n>', '<Esc>:RunCode<CR>', { noremap = true, silent = false, desc = 'Run Code' })

  end,
}
