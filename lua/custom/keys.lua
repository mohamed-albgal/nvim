local function map(arg)
  local mode = arg.mode or 'n'
  local defaults = { noremap = true, silent = true, desc = arg.desc }
  vim.api.nvim_set_keymap(mode, arg.key, arg.cmd, defaults)
end

-- map{ key =   '<leader>wt',  cmd = '<cmd>lua local m=require("custom.widen") if m.isWide then m.isWide = false vim.cmd("wincmd = | echom \'---Widening off--- \'") else m.isWide=true m.widen() end<cr>', desc = "vscode's buffer width switch toggle" }
map{ key =   '<leader>wt',  cmd = ':WindowsToggleAutowidth<cr>', desc = "vscode's buffer width switch toggle" }
map{ key =   '<leader>wm',  cmd = ':WindowsMaximize<cr>', desc = "vscode's buffer width switch toggle" }
map{ key =   '<leader>w=',  cmd = ':WindowsEqualize<cr>', desc = "vscode's buffer width switch toggle" }
map{ key =   '<leader>wn',  cmd = ':tabdo windo set number!<cr>', desc = 'Toggle line numbers' }
map{ key =   '<leader>wr',  cmd = ':set relativenumber<cr>', desc = 'Toggle relative line numbers' }
map{ key =   '<leader>w',   cmd = '<C-w>', desc = 'Window navigation' }
map{ key =   '<leader>z',   cmd = ':Z<cr>', desc= "Zen mode" }
map{ key =   '<leader>/',   cmd = 'g*', desc = "Search for word under cursor" }
map{ key =   '<leader>l',   cmd = ':wincmd l<cr>'}
map{ key =   '<leader>a',   cmd = ':wincmd h<cr>' }
map{ key =   '<leader>d',   cmd = ':bd!<CR>',  desc="Close buffer"}
map{ key =   '<leader>w/',  cmd = ':vertical sb<CR>',  desc="Open vertical split"}
map{ key =   '<leader>w-',  cmd = ':split<CR>',  desc="Open horizontal split" }
map{ key =   '<leader>;',   cmd = ":FloatermToggle<CR>",  desc = "Toggle terminal" }
map{ key =   '<leader>tn',  cmd = ":FloatermNext<CR>",  desc = "Next terminal" }
map{ key =   '<leader>tT',  cmd = ":FloatermNew<CR>",  desc = "New terminal" }
map{ key =   '<leader>tp',  cmd = ":FloatermPrev<CR>",  desc = "Previous terminal" }
map{ key =   '<C-l>',       cmd =':tabnext<CR>',  desc = "Previous buffer"}
map{ key =   '<C-h>',       cmd =':tabprevious<CR>',  desc = "Next buffer"}
map{ key =   '<leader>T',   cmd =':tabnew<CR>',  desc = "Next buffer"}
map{ key =   '<leader>gg',  cmd =":LazyGit<cr>",  desc = 'LazyGit window' }
map{ mode = 't', key = '<leader><ESC>', cmd = "<C-\\><C-n>",   desc = "Exit normal mode" }
map{ mode = 't', key = '<leader>;',     cmd = "<C-\\><C-n>:FloatermToggle<CR>",  desc = "Toggle terminal in terminal mode" }
map{ mode = 't', key = '<leader>\\',    cmd = "<C-\\><C-n>:FloatermNew<CR>",  desc = "New terminal in terminal mode" }
map{ mode = 't', key = '<leader>]',     cmd = "<C-\\><C-n>:FloatermNext<CR>",  desc = "Next terminal in terminal mode" }
map{ mode = 't', key = '<leader>[',     cmd = "<C-\\><C-n>:FloatermPrev<CR>",   desc = "Previous terminal in terminal mode" }
map{ mode = 't', key = '<leader><BS>',  cmd = "<C-\\><C-n>:FloatermKill<CR>",   desc = "Kill terminal in terminal mode" }
map{ mode = 'n', key = '<leader>jt',    cmd = ":lua j=require('custom.jou_funcs') j.openToday()<CR>",   desc = "Open today's journal" }
map{ mode = 'n', key = '<leader>jh',    cmd = ':lua j=require("custom.jou_funcs") j.openPrev()<CR>', }
map{ mode = 'n', key = '<leader>jl',    cmd = ':lua j=require("custom.jou_funcs") j.openNext()<CR>', }
map{ mode = 'n', key = '<leader>ja',    cmd = ":lua j=require('custom.jou_funcs') j.addTask()<CR>",  desc = "Add task to journal" }

-- diagnostics toggle
local hideFunc = function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  else
    vim.diagnostic.enable()
  end
end
vim.keymap.set('n', '<leader>wd', hideFunc, { desc = 'Toggle diagnostics' })
