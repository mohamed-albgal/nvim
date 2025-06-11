vim.opt.termguicolors = true

-- Set highlight on search
vim.o.hlsearch = true

-- enable mouse mode
vim.o.mouse = 'a'
--
-- set timeoutlen
vim.o.timeoutlen = 550


-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.cindent = true
vim.o.expandtab = true
vim.o.smartindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
--vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Define custom diagnostic signs
vim.fn.sign_define('DiagnosticSignError', { text ='▷', texthl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

-- the above is deprecated, use the following instead, but it doesn't work... 
-- vim.diagnostic.config({
--   signs = {
--     text = {
--       [vim.diagnostic.severity.ERROR] = '▷',
--     },
--     linehl = {
--       [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
--     },
--     numhl = {
--       [vim.diagnostic.severity.WARN] = 'WarningMsg',
--     },
--   },
-- })

-- Diagnostics configuration
vim.diagnostic.config({
  underline = true,
  virtual_text = false,
  signs = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
})
