-- ============================================================================
--                        Neovim VS Code Style Keymaps
-- ============================================================================

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }

-- Disable spacebar default behavior
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 's', '<Nop>', opts)

-- Clear search highlight on Esc
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- ============================================================================
-- 1. VS Code Style Text Selection (Shift + Arrows & Ctrl + Shift + Arrows)
-- ============================================================================

-- Normal Mode: Start visual selection with Shift + Arrows
vim.keymap.set('n', '<S-Left>', 'vh', { desc = 'Select left' })
vim.keymap.set('n', '<S-Right>', 'vl', { desc = 'Select right' })
vim.keymap.set('n', '<S-Up>', 'vk', { desc = 'Select up' })
vim.keymap.set('n', '<S-Down>', 'vj', { desc = 'Select down' })
vim.keymap.set('n', '<C-S-Left>', 'vb', { desc = 'Select word left' })
vim.keymap.set('n', '<C-S-Right>', 've', { desc = 'Select word right' })
vim.keymap.set('n', '<S-Home>', 'v^', { desc = 'Select to start of line' })
vim.keymap.set('n', '<S-End>', 'v$', { desc = 'Select to end of line' })
vim.keymap.set('n', '<C-S-Home>', 'vgg', { desc = 'Select to top of file' })
vim.keymap.set('n', '<C-S-End>', 'vG$', { desc = 'Select to end of file' })

-- Visual Mode: Extend selection
vim.keymap.set('x', '<S-Left>', 'h', opts)
vim.keymap.set('x', '<S-Right>', 'l', opts)
vim.keymap.set('x', '<S-Up>', 'k', opts)
vim.keymap.set('x', '<S-Down>', 'j', opts)
vim.keymap.set('x', '<C-S-Left>', 'b', opts)
vim.keymap.set('x', '<C-S-Right>', 'e', opts)
vim.keymap.set('x', '<S-Home>', '^', opts)
vim.keymap.set('x', '<S-End>', '$', opts)
vim.keymap.set('x', '<C-S-Home>', 'gg', opts)
vim.keymap.set('x', '<C-S-End>', 'G$', opts)

-- Insert Mode: Start visual selection with Shift + Arrows
vim.keymap.set('i', '<S-Left>', '<Esc>vh', { desc = 'Select left' })
vim.keymap.set('i', '<S-Right>', '<Esc>lvh', { desc = 'Select right' })
vim.keymap.set('i', '<S-Up>', '<Esc>vk', { desc = 'Select up' })
vim.keymap.set('i', '<S-Down>', '<Esc>vj', { desc = 'Select down' })
vim.keymap.set('i', '<C-S-Left>', '<Esc>vb', { desc = 'Select word left' })
vim.keymap.set('i', '<C-S-Right>', '<Esc>lve', { desc = 'Select word right' })
vim.keymap.set('i', '<S-Home>', '<Esc>v^', { desc = 'Select to start of line' })
vim.keymap.set('i', '<S-End>', '<Esc>v$', { desc = 'Select to end of line' })
vim.keymap.set('i', '<C-S-Home>', '<Esc>vgg', { desc = 'Select to top of file' })
vim.keymap.set('i', '<C-S-End>', '<Esc>vG$', { desc = 'Select to end of file' })

-- ============================================================================
-- 2. Delete Selected Text with Backspace or Delete (without overwriting clipboard)
-- ============================================================================
vim.keymap.set({ 'v', 'x' }, '<BS>', '"_d', { desc = 'Delete selected text' })
vim.keymap.set({ 'v', 'x' }, '<Del>', '"_d', { desc = 'Delete selected text' })

-- ============================================================================
-- 3. Cursor Navigation (Ctrl + Left/Right, Home, End)
-- ============================================================================
-- Word jump navigation (Ctrl + Left / Right)
vim.keymap.set('n', '<C-Left>', 'b', opts)
vim.keymap.set('n', '<C-Right>', 'w', opts)
vim.keymap.set('i', '<C-Left>', '<C-o>b', opts)
vim.keymap.set('i', '<C-Right>', '<C-o>w', opts)
vim.keymap.set('x', '<C-Left>', 'b', opts)
vim.keymap.set('x', '<C-Right>', 'w', opts)

-- Home and End
vim.keymap.set('n', '<Home>', '^', opts)
vim.keymap.set('n', '<End>', '$', opts)
vim.keymap.set('i', '<Home>', '<C-o>^', opts)
vim.keymap.set('i', '<End>', '<C-o>$', opts)
vim.keymap.set('x', '<Home>', '^', opts)
vim.keymap.set('x', '<End>', '$', opts)

-- Wrapped lines navigation with j, k
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ============================================================================
-- 4. VS Code Standard Clipboard (Ctrl + A, Ctrl + C, Ctrl + X, Ctrl + V)
-- ============================================================================
-- Select All (Ctrl + A)
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })
vim.keymap.set('i', '<C-a>', '<Esc>ggVG', { desc = 'Select all' })
vim.keymap.set('x', '<C-a>', '<Esc>ggVG', { desc = 'Select all' })

-- Copy (Ctrl + C)
vim.keymap.set({ 'v', 'x' }, '<C-c>', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set('n', '<C-c>', '"+yy', { desc = 'Copy line to clipboard' })

-- Cut (Ctrl + X)
vim.keymap.set({ 'v', 'x' }, '<C-x>', '"+d', { desc = 'Cut to clipboard' })

-- Paste (Ctrl + V)
vim.keymap.set('n', '<C-v>', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'v', 'x' }, '<C-v>', '"+p', { desc = 'Paste from clipboard' })

-- Delete character with 'x' without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Keep last yanked when pasting over selection
vim.keymap.set('v', 'p', '"_dP', opts)

-- System clipboard leader mappings
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- ============================================================================
-- 5. Undo / Redo (Ctrl + Z, Ctrl + Y, Ctrl + Shift + Z)
-- ============================================================================
-- Undo (Ctrl + Z)
vim.keymap.set('n', '<C-z>', 'u', { desc = 'Undo' })
vim.keymap.set('i', '<C-z>', '<C-o>u', { desc = 'Undo' })
vim.keymap.set('x', '<C-z>', '<Esc>u', { desc = 'Undo' })

-- Redo (Ctrl + Y or Ctrl + Shift + Z)
vim.keymap.set('n', '<C-y>', '<C-r>', { desc = 'Redo' })
vim.keymap.set('i', '<C-y>', '<C-o><C-r>', { desc = 'Redo' })
vim.keymap.set('n', '<C-S-z>', '<C-r>', { desc = 'Redo' })
vim.keymap.set('i', '<C-S-z>', '<C-o><C-r>', { desc = 'Redo' })

-- ============================================================================
-- 6. Save & Quit (Ctrl + S, Ctrl + Q)
-- ============================================================================
vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', { desc = 'Save without formatting' })
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', { desc = 'Quit' })

-- ============================================================================
-- 7. Line Moving & Duplication (Alt + Up/Down, Shift + Alt + Up/Down)
-- ============================================================================
-- Move line up/down (Alt + Up / Alt + Down and Alt + j / Alt + k)
vim.keymap.set('n', '<A-Down>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-Up>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })

vim.keymap.set('i', '<A-Down>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-Up>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move line up' })
vim.keymap.set('i', '<A-j>', '<Esc><cmd>m .+1<CR>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<Esc><cmd>m .-2<CR>==gi', { desc = 'Move line up' })

vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Duplicate line (Shift + Alt + Up / Down and Shift + Alt + j / k)
vim.keymap.set('n', '<A-S-Down>', '<cmd>t.<CR>', { desc = 'Duplicate line down' })
vim.keymap.set('n', '<A-S-Up>', '<cmd>t.-1<CR>', { desc = 'Duplicate line up' })
vim.keymap.set('n', '<A-S-j>', '<cmd>t.<CR>', { desc = 'Duplicate line down' })
vim.keymap.set('n', '<A-S-k>', '<cmd>t.-1<CR>', { desc = 'Duplicate line up' })

vim.keymap.set('i', '<A-S-Down>', '<Esc><cmd>t.<CR>gi', { desc = 'Duplicate line down' })
vim.keymap.set('i', '<A-S-Up>', '<Esc><cmd>t.-1<CR>gi', { desc = 'Duplicate line up' })
vim.keymap.set('i', '<A-S-j>', '<Esc><cmd>t.<CR>gi', { desc = 'Duplicate line down' })
vim.keymap.set('i', '<A-S-k>', '<Esc><cmd>t.-1<CR>gi', { desc = 'Duplicate line up' })

vim.keymap.set('v', '<A-S-Down>', ":'<,'>t '><CR>gv=gv", { desc = 'Duplicate selection down' })
vim.keymap.set('v', '<A-S-Up>', ":'<,'>t '<-1<CR>gv=gv", { desc = 'Duplicate selection up' })

-- Delete Line (Ctrl + Shift + K)
vim.keymap.set('n', '<C-S-k>', '<cmd>d<CR>', { desc = 'Delete current line' })
vim.keymap.set('i', '<C-S-k>', '<Esc><cmd>d<CR>i', { desc = 'Delete current line' })

-- Insert line above/below without breaking current line (Ctrl + Enter / Ctrl + Shift + Enter)
vim.keymap.set('i', '<C-CR>', '<Esc>o', { desc = 'Insert line below' })
vim.keymap.set('i', '<C-S-CR>', '<Esc>O', { desc = 'Insert line above' })

-- ============================================================================
-- 8. Comments (Ctrl + /)
-- ============================================================================
vim.keymap.set('n', '<C-/>', 'gcc', { remap = true, silent = true, desc = 'Toggle comment' })
vim.keymap.set('n', '<C-_>', 'gcc', { remap = true, silent = true, desc = 'Toggle comment' })
vim.keymap.set('v', '<C-/>', 'gc', { remap = true, silent = true, desc = 'Toggle comment' })
vim.keymap.set('v', '<C-_>', 'gc', { remap = true, silent = true, desc = 'Toggle comment' })
vim.keymap.set('i', '<C-/>', '<Esc>gcca', { remap = true, silent = true, desc = 'Toggle comment' })
vim.keymap.set('i', '<C-_>', '<Esc>gcca', { remap = true, silent = true, desc = 'Toggle comment' })

-- ============================================================================
-- 9. VS Code IDE Panels & Search (Ctrl + B, Ctrl + P, Ctrl + Shift + F, Ctrl + F)
-- ============================================================================
-- Toggle Sidebar Explorer (Ctrl + B & <leader>e)
vim.keymap.set({ 'n', 'i' }, '<C-b>', '<cmd>Neotree toggle position=left<CR>', { desc = 'Toggle Explorer' })
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle position=left<CR>', { desc = 'Toggle Explorer' })

-- Quick Open files (Ctrl + P)
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>', { desc = 'Quick Open File' })

-- Find in files (Ctrl + Shift + F)
vim.keymap.set('n', '<C-S-f>', '<cmd>Telescope live_grep<CR>', { desc = 'Find in Files' })

-- Find in current file (Ctrl + F)
vim.keymap.set('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<CR>', { desc = 'Find in buffer' })

-- Replace in file (Ctrl + H)
vim.keymap.set('n', '<C-h>', ':%s/', { desc = 'Find and Replace' })

-- ============================================================================
-- 10. Indentation & Tab Navigation
-- ============================================================================
-- Stay in visual mode while indenting
vim.keymap.set('v', '<Tab>', '>gv', opts)
vim.keymap.set('v', '<S-Tab>', '<gv', opts)
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Quick exit from insert mode
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- Buffers & Tabs
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<C-i>', '<C-i>', opts)
vim.keymap.set('n', '<leader>x', ':Bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts)

-- Window Splits Management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<leader>h', '<C-w>s', opts)
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts)
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)

-- Toggle line wrap
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Diagnostics
local diagnostics_active = true
vim.keymap.set('n', '<leader>do', function()
  diagnostics_active = not diagnostics_active
  vim.diagnostic.enable(diagnostics_active)
end, { desc = 'Toggle diagnostics' })

vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Previous diagnostic' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next diagnostic' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Floating diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })

-- Session management
vim.keymap.set('n', '<leader>ss', ':mksession! .session.vim<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>sl', ':source .session.vim<CR>', { noremap = true, silent = false })
