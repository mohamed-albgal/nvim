local function map(arg)
  vim.api.nvim_set_keymap(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

map{ key='<leader>wn',     cmd= ':lua require("custom/line_num").toggle()<CR>',         desc = "Toggle line numbers" }
map{ key='<leader>wr',     cmd= ':lua require("custom/line_num").toggleRelative()<CR>', desc = "Toggle relative line numbers" }

map{ key='<leader>wh',     cmd= ':nohlsearch<CR>',              desc = "Clear search highlights" }
map{ key='<leader>wt',     cmd= ':WindowsToggleAutowidth<cr>',  desc = "Toggle AutoWidth" }
map{ key='<leader>wm',     cmd= ':WindowsMaximize<cr>',         desc = "Maximize buffer" }
map{ key='<leader>w=',     cmd= ':WindowsEqualize<cr>',         desc = "Equalize Buffer sizes" }
map{ key='<leader>w',      cmd= '<C-w>',                        desc = "Window navigation" }
map{ key='<leader>z',      cmd= ':Z<cr>',                       desc = "Zen mode" }
map{ key='<leader>l',      cmd= ':wincmd l<cr>',                desc = "Go right" }
map{ key='<leader>a',      cmd= ':wincmd h<cr>',                desc = "Go left" }
map{ key='<leader>/',      cmd= 'g*',                           desc = "Search for word under cursor" }
map{ key='<leader>d',      cmd= ':bd!<CR>',                     desc = "Close buffer"}
map{ key='<leader>w/',     cmd= ':vertical sb<CR>',             desc = "Open vertical split" }
map{ key='<leader>w-',     cmd= ':split<CR>',                   desc = "Open horizontal split"}
map{ key='<leader>;',      cmd= ":FloatermToggle<CR>",          desc = "Toggle terminal" }
map{ key='<C-l>',          cmd= ':tabnext<CR>',                 desc = "Next tab"}
map{ key='<C-h>',          cmd= ':tabprevious<CR>',             desc = "Prev tab"}
map{ key='<leader>T',      cmd= ':tabnew<CR>',                  desc = "New tab" }
map{ key='<leader>gg',     cmd= ":LazyGit<cr>",                 desc = 'LazyGit window' }
map{ key='<leader>jt',     cmd= ":OpenJournal<cr>",             desc = "Open today's journal" }
map{ key='<leader>jh',     cmd= ':OpenPrevJournal<cr>',         desc = "Open previous journal entry" }
map{ key='<leader>jl',     cmd= ':OpenNextJournal<cr>',         desc = "Open next journal entry" }
map{ key='<leader>ja',     cmd= ":AddJournalTask<cr>",          desc = "Add task to journal" }
map{ key='<leader>r.',     cmd= ':RunRspec false<CR>',          desc = 'Run the test under the cursor' }
map{ key='<leader>rw',     cmd= ':RunRspec true<CR>',           desc = 'Run the whole test file' }
map{ key='<Leader>rf',     cmd= ':YankRspecFile<CR>',           desc = "Yank the test file signature" }
map{ key='<Leader>ry',     cmd= ':YankRspecTest<CR>',           desc = "Yank the test signature under the cursor" }
-- Terminal mode mappings
map{ mode='t', key='<leader><ESC>', cmd="<C-\\><C-n>",                                  desc = "Exit normal mode" }
map{ mode='t', key='<leader>;',     cmd="<C-\\><C-n>:FloatermToggle<CR>",               desc = "Toggle terminal in terminal mode" }
map{ mode='t', key='<leader>\\',    cmd="<C-\\><C-n>:FloatermNew<CR>",                  desc = "New terminal in terminal mode" }
map{ mode='t', key='<leader>]',     cmd="<C-\\><C-n>:FloatermNext<CR>",                 desc = "Next terminal in terminal mode" }
map{ mode='t', key='<leader>[',     cmd="<C-\\><C-n>:FloatermPrev<CR>",                 desc = "Previous terminal in terminal mode" }
map{ mode='t', key='<leader><BS>',  cmd="<C-\\><C-n>:FloatermKill<CR>",                 desc = "Kill terminal in terminal mode" }

-- diagnostics toggle
vim.keymap.set('n', '<leader>wd', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
  else
    vim.diagnostic.disable()
  end
end, { desc = 'Toggle diagnostics' })
