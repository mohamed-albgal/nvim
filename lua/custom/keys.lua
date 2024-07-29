local function map(arg)
  vim.api.nvim_set_keymap(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

-- Normal mode mappings
map{ key = '<leader>wn',     cmd = ':tabdo windo set number!<cr>',    desc = "Toggle line numbers" }
map{ key = '<leader>wr',     cmd = ':set relativenumber<cr>',         desc = "Toggle relative line numbers" }
map{ key = '<leader>wt',     cmd = ':WindowsToggleAutowidth<cr>',     desc = "vscode's buffer width switch toggle" }
map{ key = '<leader>wm',     cmd = ':WindowsMaximize<cr>',            desc = "vscode's buffer width switch toggle" }
map{ key = '<leader>w=',     cmd = ':WindowsEqualize<cr>',            desc = "vscode's buffer width switch toggle" }
map{ key = '<leader>w',      cmd = '<C-w>',                           desc = "Window navigation" }
map{ key = '<leader>z',      cmd = ':Z<cr>',                          desc = "Zen mode" }
map{ key = '<leader>l',      cmd = ':wincmd l<cr>',                   desc = "Search for word under cursor" }
map{ key = '<leader>a',      cmd = ':wincmd h<cr>',                   desc = "Search for word under cursor" }
map{ key = '<leader>/',      cmd = 'g*',                              desc = "Search for word under cursor" }
map{ key = '<leader>d',      cmd = ':bd!<CR>',                        desc ="Close buffer"}
map{ key = '<leader>w/',     cmd = ':vertical sb<CR>',                desc ="Open vertical split" }
map{ key = '<leader>w-',     cmd = ':split<CR>',                      desc = "Open horizontal split"}
map{ key = '<C-l>',          cmd = ':tabnext<CR>',                    desc = "Previous buffer"}
map{ key = '<leader>;',      cmd = ":FloatermToggle<CR>",             desc = "Toggle terminal" }
map{ key = '<C-h>',          cmd = ':tabprevious<CR>',                desc = "Next buffer"}
map{ key = '<leader>T',      cmd = ':tabnew<CR>',                     desc = "Next buffer"}
map{ key = '<leader>gg',     cmd = ":LazyGit<cr>",                    desc = 'LazyGit window' }
map{ key = '<leader>r.',     cmd = ':lua RunRSpec(false)<CR>',        desc = 'Run test in current file' }
map{ key = '<leader>rw',     cmd = ':lua RunRSpec(true)<CR>' }
map{ key = '<leader>jt',     cmd = ":OpenJournal<cr>",                desc = "Open today's journal" }
map{ key = '<leader>jp',     cmd = ':OpenPrevJournal<cr>',            desc = "Open previous journal entry" }
map{ key = '<leader>jn',     cmd = ':OpenNextJournal<cr>',            desc = "Open next journal entry" }
map{ key = '<leader>ja',     cmd = ":AddJournalTask<cr>",             desc = "Add task to journal" }
map{ key = '<Leader>rf',     cmd = ":let @+ = 'rspec ' . expand('%')<CR>",                   desc = "copy rspec [f]ile signature" }
map{ key = '<Leader>ry',     cmd = ":let @+ = 'rspec ' . expand('%') . ':' . line('.')<CR>", desc = "[y]ank rspec line signature" }

-- Terminal mode mappings
map{ mode = 't', key = '<leader><ESC>', cmd = "<C-\\><C-n>",                    desc = "Exit normal mode" }
map{ mode = 't', key = '<leader>;',     cmd = "<C-\\><C-n>:FloatermToggle<CR>", desc = "Toggle terminal in terminal mode" }
map{ mode = 't', key = '<leader>\\',    cmd = "<C-\\><C-n>:FloatermNew<CR>",    desc = "New terminal in terminal mode" }
map{ mode = 't', key = '<leader>]',     cmd = "<C-\\><C-n>:FloatermNext<CR>",   desc = "Next terminal in terminal mode" }
map{ mode = 't', key = '<leader>[',     cmd = "<C-\\><C-n>:FloatermPrev<CR>",   desc = "Previous terminal in terminal mode" }
map{ mode = 't', key = '<leader><BS>',  cmd = "<C-\\><C-n>:FloatermKill<CR>",   desc = "Kill terminal in terminal mode" }

-- diagnostics toggle
vim.keymap.set('n', '<leader>wd', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = 'Toggle diagnostics' })
