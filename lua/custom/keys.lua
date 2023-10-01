
-- -- Define a variable to control whether to equalize on window navigation
local equalize_enabled = false
-- Define a function to make windows equal width and increase buffer width
function equalize_windows_and_increase_width()
    -- Make windows equal width
    vim.cmd("wincmd =")

    -- Increase buffer width by 40 columns
    vim.cmd("vertical resize +80")
end

-- Map the function to the <leader>wt key sequence
-- vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua equalize_windows_and_increase_width()<cr>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua equalize_enabled = not equalize_enabled<cr>:lua equalize_windows_and_increase_width()', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua if equalize_enabled then vim.cmd("wincmd =") else equalize_enabled = true equalize_and_increase_width() end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wt', '<cmd>lua if equalize_enabled then equalize_enabled = false vim.cmd("wincmd = | echom \'equalize_enabled is true\'") else equalize_enabled=true equalize_windows_and_increase_width() vim.cmd("echom \'equalize_enabled is false\'") end<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w>', { noremap=true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>a', '<C-w>h', { noremap=true, silent = false})

-- Map <leader>a to navigate left (equivalent to <C-w>h) and trigger equalize if enabled
vim.api.nvim_set_keymap('n', '<leader>a', ':wincmd h<cr>:lua if equalize_enabled then equalize_windows_and_increase_width() end<cr>', { noremap = true, silent = true })

-- Map <leader>l to navigate right (equivalent to <C-w>l) and trigger equalize if enabled
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<cr>:lua if equalize_enabled then equalize_windows_and_increase_width() end<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>d', ':bd!<CR>', { noremap=true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>w/', ':vertical sb<CR>', { noremap=true, silent = false})
vim.api.nvim_set_keymap('n', '<leader>w-', ':split<CR>', { noremap=true, silent = false})
vim.api.nvim_set_keymap('n', '<leader>tt', ":FloatermToggle<CR>", { noremap=true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tn', ":FloatermNew<CR>", { noremap=true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>t;', ":FloatermPrev<CR>", { noremap=true, silent = true})
vim.api.nvim_set_keymap('t', 'kj', "<C-\\><C-n>", { noremap=true, silent = true})
vim.keymap.set({'n','v','i'}, '<C-h>', ":BufferLineCyclePrev<cr>", { noremap=true, silent = true})
vim.keymap.set({'n','v','i'}, '<C-l>', ":BufferLineCycleNext<cr>", { noremap=true, silent = true})
vim.keymap.set({'n','v','i'}, '<C-l>', ":BufferLineCycleNext<cr>", { noremap=true, silent = true})
vim.keymap.set('n', '<leader>bD', ":BufferLineCloseOthers<cr>", { noremap=true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gg', ":LazyGit<cr>", { silent = true, desc = 'LazyGit window' })
vim.api.nvim_set_keymap('n', '<C-w>h', ':lua if equalize_enabled then equalize_windows_and_increase_width() else vim.cmd("wincmd h") end<cr>', { noremap = true, silent = true })
