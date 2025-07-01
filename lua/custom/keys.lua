local map = require('custom.helpers').map

map{ key='<leader>jt',     cmd= require("custom.jou_funcs").openToday,                  desc = "Open today's journal" }
map{ key='<leader>jh',     cmd= require("custom.jou_funcs").openPrev,                   desc = "Open previous journal entry" }
map{ key='<leader>jl',     cmd= require("custom.jou_funcs").openNext,                   desc = "Open next journal entry" }
map{ key='<leader>ja',     cmd= require("custom.jou_funcs").addTask,                    desc = "Add task to journal" }
map{ key='<Leader>jf',     cmd= require("custom.jou_funcs").sideNote,                   desc = "Open/create side note" }
map{ key='<Leader>jo',     cmd= require("custom.jou_funcs").sideNoteContext,            desc = "Open/create side note" }

map{ key='<leader>r.',     cmd= ':RunRspec false<CR>',                                  desc = 'Run the test under the cursor' }
map{ key='<leader>rw',     cmd= ':RunRspec true<CR>',                                   desc = 'Run the whole test file' }
map{ key='<leader>wn',     cmd= require("custom/line_num").toggle,                      desc = "Toggle line numbers" }
map{ key='<leader>rx',     cmd= require("custom.run_rspec").cleanLines,                 desc = 'Clean failing rspec lines' }
map{ key='<Leader>rf',     cmd= require("custom.run_rspec").yankFile,                   desc = "Yank the test file signature" }
map{ key='<Leader>ry',     cmd= require("custom.run_rspec").yankTest,                   desc = "Yank the test signature under the cursor" }
map{ key='<leader>S',      cmd= require("custom.story").story,                          desc = "Beautify (format) entire file" }
map{ key='<leader>h.',     cmd= require("custom.pins").pinThis,                         desc = "Pin current buffer" }

map{ key='<leader>hx',     cmd= require("custom.pins").unpinThis,                       desc = "Clear all pinned buffers" }
map{ key='<leader>hD',     cmd= require("custom.pins").clearPins,                       desc = "Clear all pinned buffers" }
map{ key='<leader>hh',      cmd= require("custom.pins").showPins,                        desc = "Show pinned buffers" }
map{ key='<leader>hv',     cmd= require("custom.pins").splitPins,                       desc = "Split pinned buffers" }
map{ key='<leader>p',     cmd= require("custom.pins").nextPin,                          desc = "Next pinned buffer" }
map{ key='<leader>h1',     cmd= ":GoToPinned 1<CR>",                                    desc = "Go to pinned buffer 1" }
map{ key='<leader>h2',     cmd= ":GoToPinned 2<CR>",                                    desc = "Go to pinned buffer 2" }
map{ key='<leader>h3',     cmd= ":GoToPinned 3<CR>",                                    desc = "Go to pinned buffer 3" }
map{ key='<leader>h4',     cmd= ":GoToPinned 4<CR>",                                    desc = "Go to pinned buffer 4" }

map{ key='<leader>hd',     cmd= ":DelPin 1<CR>",                                       desc = "Go to pinned buffer 1" }
map{ key='<leader>hd2',     cmd= ":DelPin 2<CR>",                                       desc = "Go to pinned buffer 2" }
map{ key='<leader>hd3',     cmd= ":DelPin 3<CR>",                                       desc = "Go to pinned buffer 3" }
map{ key='<leader>hd4',     cmd= ":DelPin 4<CR>",                                       desc = "Go to pinned buffer 4" }

map{ key='<leader>wh',     cmd= ':nohlsearch<CR>',                                      desc = "Clear search highlights" }
map{ key='ESC',            cmd= ':nohlsearch<CR>',                                      desc = "Clear search highlights" }
map{ key='<leader>wt',     cmd= ':WindowsToggleAutowidth<cr>',                          desc = "Toggle AutoWidth" }
map{ key='<leader>wm',     cmd= ':WindowsMaximize<cr>',                                 desc = "Maximize buffer" }
map{ key='<leader>w=',     cmd= ':WindowsEqualize<cr>',                                 desc = "Equalize Buffer sizes" }
map{ key='<C-k>',          cmd= '<C-w>k',                                               desc = "Window navigation up" }
map{ key='<C-j>',          cmd= '<C-w>j',                                               desc = "Window navigation down" }
map{ key='<C-h>',          cmd= '<C-w>h',                                               desc = "Window navigation right" }
map{ key='<C-l>',          cmd= '<C-w>l',                                               desc = "Window navigation down" }
map{ key='<leader>z',      cmd= function() Snacks.zen() end,                                               desc = "Zen mode" }
map{ key='<leader>l',      cmd= ':wincmd l<cr>',                                        desc = "Go right" }
map{ key='<leader>a',      cmd= ':wincmd h<cr>',                                        desc = "Go left" }
map{ key='<leader>/',      cmd= 'g*',                                                   desc = "Search for word under cursor" }
map{ key='<leader>d',      cmd= ':bd!<CR>',                                             desc = "Close buffer"}
map{ key='<leader>w/',     cmd= ':vertical sb<CR>',                                     desc = "Open vertical split" }
map{ key='<leader>w-',     cmd= ':split<CR>',                                           desc = "Open horizontal split"}
map{ key='<leader>bb',     cmd= ':b#<CR>',                                              desc = "Switch between buffers" }
map{ key='<leader>;',      cmd= ":FloatermToggle<CR>",                                  desc = "Toggle terminal" }
map{ key='<leader>Tn',     cmd= ':tabn<CR>',                                            desc = "New tab" }
map{ key='<leader>Tp',     cmd= ':tabp<CR>',                                            kjdesc = "New tab" }
map{ key='<leader>TT',     cmd= ':tabnew<CR>',                                          desc = "New tab" }
map{ key='<leader>gg',     cmd= ":LazyGit<cr>",                                         desc = 'LazyGit window' }
map{ key='<Leader>e',      cmd= ':Oil --float<CR>',                                     desc = "Open Oil in float mode" }
map{ key='<Leader>e',      cmd= require('oil').toggle_float,                            desc = "Open Oil in float mode" }
map{ key='<leader>be',     cmd= require('custom.helpers').bufFormat,                           desc = "Beautify (format) entire file" }
map{ key='<leader>bE',     cmd= function() require('custom.helpers').bufFormat(true) end,      desc = "Beautify (format) entire file" }
-- mapping for page up and page down
map{ key='<Leader>sf', cmd='<C-f>', desc = 'Scroll half page up' }
map{ key='<Leader>sb', cmd='<C-b>', desc = 'Scroll half page down' }

-- Terminal mode mappings
map{ mode='t', key='<leader><leader><ESC>', cmd="<C-\\><C-n>",                          desc = "Exit normal mode" }
map{ mode='t', key='<leader>;',     cmd="<C-\\><C-n>:FloatermToggle<CR>",               desc = "Toggle terminal in terminal mode" }
map{ mode='t', key='<leader>\\',    cmd="<C-\\><C-n>:FloatermNew<CR>",                  desc = "New terminal in terminal mode" }
map{ mode='t', key='<leader>]',     cmd="<C-\\><C-n>:FloatermNext<CR>",                 desc = "Next terminal in terminal mode" }
map{ mode='t', key='<leader>[',     cmd="<C-\\><C-n>:FloatermPrev<CR>",                 desc = "Previous terminal in terminal mode" }
map{ mode='t', key='<leader><BS>',  cmd="<C-\\><C-n>:FloatermKill<CR>",                 desc = "Kill terminal in terminal mode" }

-- lsp and diagnostics mappings
map{ key='<leader>E',      cmd= vim.diagnostic.open_float,                        desc = "Open floating diagnostic message" }
map{ key='<leader>rn',     cmd= vim.lsp.buf.rename,                               desc = "Buffer [R]e[n]ame" }
map{ key='gi',             cmd= vim.lsp.buf.implementation,                       desc = "[G]oto [I]mplementation" }
map{ key='gd',             cmd= require('fzf-lua').lsp_definitions,                     desc = "[G]oto [D]efinition" }
-- map{ key='gr',             cmd= require('fzf-lua').lsp_references,                      desc = "[G]oto [R]eferences" }
map{ key='<leader>bs',     cmd= require('fzf-lua').lsp_document_symbols,                desc = "[D]ocument [S]ymbols" }
map{ key='<leader>ws',     cmd= require('fzf-lua').lsp_live_workspace_symbols,          desc = "[W]orkspace [S]ymbols" }

-- toggle virtual diagnostics
map({ key='<leader>wl',    cmd= require('custom.helpers').toggleVirtualLines,  desc = 'Toggle diagnostic virtual_lines' } )
map({ key='<leader>wd',    cmd= require('custom.helpers').toggleVirtualUnderlines,  desc = 'Toggle diagnostics underlines'  } )
