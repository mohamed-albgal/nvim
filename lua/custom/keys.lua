vim.api.nvim_set_keymap('n', '<leader>wn', ':tabdo windo set number!<cr>', { noremap = true, silent = true, desc = "Toggle line numbers" })
vim.api.nvim_set_keymap('n', '<leader>wr', ':set relativenumber<cr>', { noremap = true, silent = true, desc = "Toggle relative line numbers" })
vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua local m=require("custom.widen") if m.isWide then m.isWide = false vim.cmd("wincmd = | echom \'---Widening off--- \'") else m.isWide=true m.widen() end<cr>', { noremap = true, silent = true, desc = "vscode's buffer width switch toggle" })
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', { noremap=true, silent = false, desc="Window navigation" })
vim.api.nvim_set_keymap('n', '<leader>a', ':wincmd h<cr>:lua local m=require("custom.widen") if m.isWide then m.widen() end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>z', ':Z<cr>', { noremap = true, silent = true, desc= "Zen mode" })
-- Map <leader>l to navigate right (equivalent to <C-w>l) and trigger equalize if --[[ enable ]]d
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<cr>:lua local m=require("custom.widen") if m.isWide then m.widen() end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>/', 'g*', { noremap = true, silent = true, desc = "Search for word under cursor" })
vim.api.nvim_set_keymap('n', '<leader>d', ':bd!<CR>', { noremap=true, silent = true, desc="Close buffer" })
vim.api.nvim_set_keymap('n', '<leader>w/', ':vertical sb<CR>', { noremap=true, silent = false, desc="Open vertical split" })
vim.api.nvim_set_keymap('n', '<leader>w-', ':split<CR>', { noremap=true, silent = false, desc="Open horizontal split" })
vim.api.nvim_set_keymap('n', '<leader>;',  ":FloatermToggle<CR>", { noremap=true, silent = true, desc = "Toggle terminal" })
vim.api.nvim_set_keymap('n', '<leader>tn', ":FloatermNext<CR>", { noremap=true, silent = true, desc = "Next terminal" })
vim.api.nvim_set_keymap('n', '<leader>tT', ":FloatermNew<CR>", { noremap=true, silent = true, desc = "New terminal" })
vim.api.nvim_set_keymap('n', '<leader>tp', ":FloatermPrev<CR>", { noremap=true, silent = true, desc = "Previous terminal" })
vim.api.nvim_set_keymap('n', '<C-l>', ':tabnext<CR>', { noremap=true, silent = true, desc = "Previous buffer"})
vim.api.nvim_set_keymap('n', '<C-h>', ':tabprevious<CR>', { noremap=true, silent = true, desc = "Next buffer"})
vim.api.nvim_set_keymap('n', '<leader>T', ':tabnew<CR>', { noremap=true, silent = true, desc = "Next buffer"})
vim.api.nvim_set_keymap('n', '<leader>gg', ":LazyGit<cr>", { silent = true, desc = 'LazyGit window' })
vim.api.nvim_set_keymap('n', '<C-w>h', ':lua local m=require("custom.widen") if m.isWide then m.widen() else vim.cmd("wincmd h") end<cr>', { noremap = true, silent = true, desc = "Navigate left like vscode full-width" })
--floaterm
--set the leader in terminal mode to be <C-leader>
vim.api.nvim_set_keymap('t', '<C-;>', "<C-\\><C-n>:FloatermToggle<CR>", { noremap=true, silent = true, desc = "Toggle terminal in terminal mode" })
vim.api.nvim_set_keymap('t', '<leader><ESC>', "<C-\\><C-n>", { noremap=true, silent = true, desc = "Exit normal mode" })
-- vim.api.nvim_set_keymap('t', '<leader>;', "<C-\\><C-n>:FloatermToggle<CR>", { noremap=true, silent = true, desc = "Toggle terminal in terminal mode" })
vim.api.nvim_set_keymap('t', '<leader>\\', "<C-\\><C-n>:FloatermNew<CR>", { noremap=true, silent = true, desc = "New terminal in terminal mode" })
vim.api.nvim_set_keymap('t', '<leader>]', "<C-\\><C-n>:FloatermNext<CR>", { noremap=true, silent = true, desc = "Next terminal in terminal mode" })
vim.api.nvim_set_keymap('t', '<leader>[', "<C-\\><C-n>:FloatermPrev<CR>", { noremap=true, silent = true, desc = "Previous terminal in terminal mode" })
vim.api.nvim_set_keymap('t', '<leader><BS>', "<C-\\><C-n>:FloatermKill<CR>", { noremap=true, silent = true, desc = "Kill terminal in terminal mode" })
--journal
vim.api.nvim_set_keymap('n', '<leader>jt', ":lua j=require('custom.jou_funcs') j.openToday()<CR>", { noremap = true, silent = true, desc = "Open today's journal" })
vim.api.nvim_set_keymap('n', '<leader>jh', ':lua j=require("custom.jou_funcs") j.openPrev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>jl', ':lua j=require("custom.jou_funcs") j.openNext()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ja', ":lua j=require('custom.jou_funcs') j.addTask()<CR>", { noremap = true, silent = true, desc = "Add task to journal" })

-- diagnostics toggle
vim.keymap.set('n', '<leader>wd', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = 'Toggle diagnostics' })
