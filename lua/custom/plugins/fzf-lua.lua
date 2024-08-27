local function map(arg)
  vim.api.nvim_set_keymap(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    map {
      key = '<leader>k',  desc = 'FZF Files',
      cmd = ":lua require('fzf-lua').files({ previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
    }
    map {
      key = '<leader>ic',  desc = 'FZF CSS Files',
      cmd = ":lua require('fzf-lua').files({cwd='app/assets/stylesheets', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
    }
    map {
      key = '<leader>ij',  desc = 'FZF JS Files',
      cmd = ":lua require('fzf-lua').files({cwd='app/assets/javascripts', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
    }
    map {
      key = '<leader>is',  desc = 'FZF Files',
      cmd = ":lua require('fzf-lua').files({cwd='spec/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
    }
    map {
      key = '<leader>ih',  desc = 'FZF HTML Files',
      cmd = ":lua require('fzf-lua').files({cwd='app/views/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
    }
    map {
      key = '<leader>ff',  desc = 'FZF grep',
      cmd = ":lua require('fzf-lua').grep_project()<cr>",
    }
    map {
      key = '<leader>fF',  desc = 'FZF grep, include path queries RAW',
      cmd = ":lua require('fzf-lua').grep_project({ prompt = 'RAW❯❯ ', fzf_opts= { ['--nth']='1..'}})<cr>",
    }
    map {
      key = '<leader>fK',  desc = 'Native live grep (more performant)',
      cmd = ":lua require('fzf-lua').live_grep_native({ prompt = 'rg❯❯ '})<cr>",
    }
    map {
      key = '<leader>fk',  desc = 'Glob support',
      cmd = ":lua require('fzf-lua').live_grep_glob({ prompt = '❯❯ '})<cr>",
    }
    map {
      key = '<leader>fs',  desc = 'FZF specs',
      cmd = ":lua require('fzf-lua').grep({prompt= 'SPECS❯❯ ', search = ' -- spec/** !*fixtures*', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fy',  desc = 'FZF specs',
      cmd = ":lua require('fzf-lua').grep({prompt= 'YAML❯❯ ', search = ' -- config/locales/** *.yml*', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fd',  desc = 'FZF specs',
      cmd = ":lua require('fzf-lua').grep({previewer=false, winopts={height=0.3,width=0.3}, prompt= '❯  ', search = 'debugger -- !*config*', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fj',  desc = 'FZF js',
      cmd = ":lua require('fzf-lua').grep({prompt= 'JAVASCRIPT❯❯ ', search = ' -- app/assets/javascripts/**', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fc',  desc = 'FZF css',
      cmd = ":lua require('fzf-lua').grep({prompt= 'CSS❯❯ ', search = ' -- app/assets/stylesheets/**', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fh',  desc = 'FZF html',
      cmd = ":lua require('fzf-lua').grep({prompt= 'HTML❯❯ ', search = ' -- app/views/**', fzf_opts = { ['--nth'] = '3..' }})<cr>",
    }
    map {
      key = '<leader>fr',   desc = 'FZF ruby (not spec)',
      cmd = ":lua require('fzf-lua').grep({prompt= 'RUBY❯❯ ', search = ' -- app/** !config/locales/** !*.yml* !app/assets/javascripts/** !app/views/** !app/assets/stylesheets/** !spec/**', fzf_opts = { ['--nth'] = '3..' }})<cr>",
   }
    map {
      key = '<leader>fb',  desc = 'fuzzy find in buffer',
      cmd = ":lua require('fzf-lua').grep_curbuf({ previewer=false, winopts = { fullscreen = false, height=0.50,width=0.60,row=0.4,col=0.5 }})<cr>",
    }
    map {
      key = '<leader>fB',  desc = 'fuzzy find in buffer',
      cmd = ":lua require('fzf-lua').lgrep_curbuf({previewer=false,fzf_opts = {['--layout']='reverse-list'}, winopts = { fullscreen = false, height=0.50,width=0.65,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>",
    }
    map {
      key = '<leader>fl',  desc = 'Continue most recent search',
      cmd = ":lua require('fzf-lua').grep_last()<cr>",
    }
    map {
      key = '<leader>f.',  desc = 'Grep word under cursor',
      cmd = ":lua require('fzf-lua').grep_cword()<cr>",
    }
    map {
      key = '<leader>fC',  desc = 'Grep WORD  under cursor',
      cmd = ":lua require('fzf-lua').grep_cWORD()<cr>",
    }
    map {
      key = '<leader>fv',  desc = 'Grep visual block',
      cmd = ":lua require('fzf-lua').grep_visual()<cr>",
    }
    map {
      key = '<leader>bk',  desc = 'Show open buffers',
      cmd = ":lua require('fzf-lua').buffers({previewer=false, winopts = { fullscreen = false, height=0.40,width=0.5,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>",
    }
    map {
      key = '<leader>fp',  desc = 'File Preview',
      cmd = ":lua require('fzf-lua').files()<cr>",
    }
    map {
      key = '<leader>gc',  desc = 'open changes made to buffer',
      cmd = ":FzfLua changes<cr>",
    }
    map {
      key = '<leader>bl',  desc = '[o]pen buffer lines',
      cmd = ":lua require('fzf-lua').lines({previewer=false})<cr>",
    }
    map {
      key = '<leader>qs',  desc = '[q]uickfix [s]tack',
      cmd = ":FzfLua quickfix_stack<cr>",
    }
    map {
      key = '<leader>qc',  desc = '[q]uickfix [c]lear',
      cmd = ":cexpr []<cr>",
    }
    map {
      key = '<leader>qn',  desc = 'next entry of quickfix list',
      cmd = ":cn<cr>",
    }
    map {
      key = '<leader>qp',  desc = 'previous entry of quickfix list',
      cmd = ":cp<cr>",
    }
    map {
      key = '<leader>qu',  desc = '[qu]ick fix list',
      cmd = ":FzfLua quickfix<cr>",
    }
    map {
      key = '<leader>ob',  desc = '[o]ld [b]uffers',
      cmd = ":FzfLua oldfiles<cr>",
    }
    map {
      key = '<leader>os',  desc = '[o]ld [s]earches',
      cmd = ":FzfLua search_history<cr>",
    }
    map {
      key = '<leader>gs',  desc = 'fzf git status',
      cmd = ":lua require('fzf-lua').git_status()<cr>",
    }
    map {
      key = '<leader>x',  desc = 'FZF builtins',
      cmd = ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>",
    }

    require('fzf-lua').setup(require('custom.fzf_custom_opts'))
  end,
}

