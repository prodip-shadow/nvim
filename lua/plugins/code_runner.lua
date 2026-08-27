return {
  'CRAG666/code_runner.nvim',
  config = function()
    require('code_runner').setup {
      -- toggleterm mode ব্যবহার করলে run terminal hide/show toggle করা যায়
      mode = 'toggleterm',
      -- এখানে বিভিন্ন ভাষার জন্য কমান্ড সেট করা আছে, চাইলে নিজের মতো এডিট করতে পারবেন
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

    -- Ctrl + Alt + n দিয়ে কোড রান করার শর্টকাট (Neovim-এ Alt-কে M বা A দিয়ে প্রকাশ করা হয়)
    vim.keymap.set('n', '<C-M-n>', ':RunCode<CR>', { noremap = true, silent = false, desc = 'Run Code' })
    vim.keymap.set('i', '<C-M-n>', '<Esc>:RunCode<CR>', { noremap = true, silent = false, desc = 'Run Code' })

  end,
}
