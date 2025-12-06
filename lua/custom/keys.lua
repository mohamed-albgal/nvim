local utils = require('custom.utils')
local map = utils.map
local pins = require("custom.pins")
local journal = require("custom.jou_funcs")
local rspec = require("custom.run_rspec")
local fzf = require("fzf-lua")
local ff = utils.ff
local side_note = require("custom.side_note").side_note
local pasteBufferPath = require("custom.utils").pasteBufferPath

map{ key='<leader>jt',     cmd= journal.openToday,             desc= "Open today's journal" }
map{ key='<leader>jh',     cmd= journal.openPrev,              desc= "Open previous journal entry" }
map{ key='<leader>jl',     cmd= journal.openNext,              desc= "Open next journal entry" }
map{ key='<leader>ja',     cmd= journal.addTask,               desc= "Add task to journal" }
map{ key='<leader>jr',     cmd= journal.rolloverTodos,         desc= "Rollover unfinished todos" }
map{ key='<Leader>jf',     cmd= side_note,                     desc= "Open/create side note" }
map{ key='<Leader>jS',     cmd= journal.openScratch,           desc= "Create a new scratch file" }
map{ key='<Leader>js',     cmd= journal.openLatestScratch,     desc= "Open the most recent scratch file" }
map{ key='<Leader>jo',     cmd= journal.openJournalDir,        desc= "Browse journal directory in Oil" }
map{ key='<leader>wn',     cmd= utils.toggleLineNums,          desc= "Toggle line numbers" }
map{ key='<leader>we', cmd= ":RenderMarkdown buf_toggle<CR>",  desc= "Toggle line numbers" }
map{ key='<leader>rx',     cmd= rspec.cleanLines,              desc= 'Clean failing rspec lines' }
map{ key='<Leader>rf',     cmd= rspec.yankFile,                desc= "Yank the test file signature" }
map{ key='<Leader>ry',     cmd= rspec.yankTest,                desc= "Yank the test signature under the cursor" }
map{ key='<leader>S',      cmd= require("custom.story").story, desc= "Paste story details in today's journal" }
map{ key='<leader>rr',     cmd= ff(pins.runAndPin,false),      desc= "Run spec under cursor" }
map{ key='<leader>rw',     cmd= ff(pins.runAndPin,true),       desc= "Run spec file" }
map{ key='<leader>ha',     cmd= pins.pinThis,                  desc= "Pin current buffer" }
map{ key='<leader>hx',     cmd= pins.unpinThis,                desc= "Clear all pinned buffers" }
map{ key='<leader>hD',     cmd= pins.clearPins,                desc= "Clear all pinned buffers" }
map{ key='<leader>hh',     cmd= pins.showPins,                 desc= "Show pinned buffers" }
map{ key='<leader>p',      cmd= pins.nextPin,                  desc= "Next pinned buffer" }
map{ key='<leader>tn',     cmd= ":tabn<CR>",                   desc= "Next tab " }
map{ key='<leader>tp',     cmd= ":tabp<CR>",                   desc= "Previous tab " }
map{ key='<leader>h1',     cmd= ":GoToPinned 1<CR>",           desc= "Go to pinned buffer 1" }
map{ key='<leader>h2',     cmd= ":GoToPinned 2<CR>",           desc= "Go to pinned buffer 2" }
map{ key='<leader>h3',     cmd= ":GoToPinned 3<CR>",           desc= "Go to pinned buffer 3" }
map{ key='<leader>h4',     cmd= ":GoToPinned 4<CR>",           desc= "Go to pinned buffer 4" }
map{ key='<leader>hd1',    cmd= ":DelPin 1<CR>",               desc= "Go to pinned buffer 1" }
map{ key='<leader>hd2',    cmd= ":DelPin 2<CR>",               desc= "Go to pinned buffer 2" }
map{ key='<leader>hd3',    cmd= ":DelPin 3<CR>",               desc= "Go to pinned buffer 3" }
map{ key='<leader>hd4',    cmd= ":DelPin 4<CR>",               desc= "Go to pinned buffer 4" }
map{ key='<leader>wh',     cmd= ':nohlsearch<CR>',             desc= "Clear search highlights" }
map{ key='<ESC>',          cmd= utils.escape_highlights,             desc= "Clear search highlights" }
map{ key='<leader>wt',     cmd= ':WindowsToggleAutowidth<cr>', desc= "Toggle AutoWidth" }
map{ key='<leader>wm',     cmd= ':WindowsMaximize<cr>',        desc= "Maximize buffer" }
map{ key='<leader>w=',     cmd= ':WindowsEqualize<cr>',        desc= "Equalize Buffer sizes" }
map{ key='<leader>z',      cmd= ff(Snacks.zen),                desc= "Zen mode" }
map{ key='<leader>l',      cmd= ':wincmd l<cr>',               desc= "Go to split right" }
map{ key='<leader>a',      cmd= ':wincmd h<cr>',               desc= "Go to split left" }
map{ key='<leader>/',      cmd= 'g*',                          desc= "Search for word under cursor" }
map{ key='<leader>d',      cmd= ':bd!<CR>',                    desc= "Close buffer"}
map{ key='<leader>w/',     cmd= ':vertical sb<CR>',            desc= "Open vertical split" }
map{ key='<leader>w-',     cmd= ':split<CR>',                  desc= "Open horizontal split"}
map{ key='<leader>bb',     cmd= ':b#<CR>',                     desc= "Switch between buffers" }
map{ key='<leader>;',      cmd= utils.rspecTermToggle,         desc= "Toggle terminal" }
map{ key='<leader>gg',     cmd= ":LazyGit<cr>",                desc= 'LazyGit window' }
map{ key='<Leader>e',      cmd= require('oil').toggle_float,   desc= "Open Oil in float mode" }
map{ key='<leader>be',     cmd= utils.bufFormat,               desc= "Beautify (format) entire file" }
map{ key='<leader>bE',     cmd= ff(utils.bufFormat,true),      desc= "Beautify (format) entire file" }
map{ key='<Leader>sf',     cmd= '<C-f>',                       desc= 'Scroll half page up' }
map{ key='<Leader>sb',     cmd= '<C-b>',                       desc= 'Scroll half page down' }
map{ key='<C-k>',          cmd= '<C-w>k',                      desc= "Window navigation up" }
map{ key='<C-j>',          cmd= '<C-w>j',                      desc= "Window navigation down" }
map{ key='<C-h>',          cmd= '<C-w>h',                      desc= "Window navigation right" }
map{ key='<C-l>',          cmd= '<C-w>l',                      desc= "Window navigation down" }
map{ key='<leader>E',      cmd= vim.diagnostic.open_float,     desc= "Open floating diagnostic message" }
map{ key='<leader>rn',     cmd= vim.lsp.buf.rename,            desc= "Buffer [R]e[n]ame" }
map{ key='<leader>bs',     cmd= fzf.lsp_document_symbols,      desc= "[D]ocument [S]ymbols" }
map{ key='<leader>ws',     cmd= fzf.lsp_live_workspace_symbols,desc= "[W]orkspace [S]ymbols" }
map{ key='<leader>wl',     cmd= utils.toggleVirtualLines,      desc= 'Toggle diagnostic virtual_lines' }
map{ key='<leader>wd',     cmd= utils.toggleVirtualUnderlines, desc= 'Toggle diagnostics underlines'  }
map{ key='gi',             cmd= vim.lsp.buf.implementation,    desc= "[G]oto [I]mplementation" }
map{ key='gd',             cmd= fzf.lsp_definitions,           desc= "[G]oto [D]efinition" }
map{ key='<leader>re',     cmd=  pasteBufferPath,              desc= "Put the path in the + register for pasting" }

map{ mode='t', key='<leader><leader><ESC>', cmd="<C-\\><C-n>",              desc= "Exit normal mode" }
map{ mode='t', key='<leader>;',     cmd="<C-\\><C-n>:FloatermToggle<CR>",   desc= "Toggle terminal in terminal mode" }
map{ mode='t', key='<leader>\\',    cmd="<C-\\><C-n>:FloatermNew<CR>",      desc= "New terminal in terminal mode" }
map{ mode='t', key='<leader>]',     cmd="<C-\\><C-n>:FloatermNext<CR>",     desc= "Next terminal in terminal mode" }
map{ mode='t', key='<leader>[',     cmd="<C-\\><C-n>:FloatermPrev<CR>",     desc= "Previous terminal in terminal mode" }
map{ mode='t', key='<leader><BS>',  cmd="<C-\\><C-n>:FloatermKill<CR>",     desc= "Kill terminal in terminal mode" }
