local function map(arg)
  vim.keymap.set(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

return {
  "ibhagwan/fzf-lua",
  config = function()

    map {
      key = '<leader>k',  desc = 'FZF Files',
      cmd = function()
        require('fzf-lua').files({ previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>K',  desc = 'FZF Files',
      cmd = function()
        require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.97,width=0.6,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>ic',  desc = 'FZF CSS Files',
      cmd = function()
        require('fzf-lua').files({cwd='app/assets/stylesheets', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>ij',  desc = 'FZF JS Files',
      cmd = function()
        require('fzf-lua').files({cwd='app/assets/javascripts', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>is',  desc = 'FZF Files',
      cmd = function()
        require('fzf-lua').files({cwd='spec/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>ih',  desc = 'FZF HTML Files',
      cmd = function()
        require('fzf-lua').files({cwd='app/views/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})
      end,
    }
    map {
      key = '<leader>fF',  desc = 'FZF grep lines (after path)',
      cmd = function()
        require('fzf-lua').grep_project()
      end,
    }
    map {
      key = '<leader>ff',  desc = 'FZF grep RAW lines',
      cmd = function()
        require('fzf-lua').grep_project({ prompt = 'RAW❯❯ ', fzf_opts= { ['--nth']='1..'}})
      end,
    }
    map {
      key = '<leader>fk',  desc = 'Glob support',
      cmd = function()
        require('fzf-lua').live_grep_glob({ prompt = '❯❯ '})
      end,
    }
    map {
      key = '<leader>fs',  desc = 'FZF specs',
      cmd = function()
        require('fzf-lua').grep({prompt= 'SPECS❯❯ ', search = ' -- spec/** !*fixtures*', fzf_opts = { ['--nth'] = '3..' }})
      end,
    }
    map {
      key = '<leader>fy',  desc = 'FZF specs',
      cmd = function()
        require('fzf-lua').grep({prompt= 'YAML❯❯ ', search = ' -- config/locales/** *.yml*', fzf_opts = { ['--nth'] = '3..' }})
      end,
    }
    map {
      key  = '<leader>fd',
      desc = 'Grep debugger in changed files',
      cmd  =  require('custom.zap').zap_debuggers,
    }

    map {
      key  = '<leader>fx',
      desc = 'Grep with TAB to zap',
      cmd  =  require('custom.zap').grep_zap,
    }

    map {
      key = '<leader>fS',  desc = 'Grep changed files',
      cmd = function()
        require('fzf-lua').grep {
          fzf_opts = { ['--nth'] = '3..' },
          raw_cmd  = [[ git status -su | rg '^\s*M' | cut -d ' ' -f3 | xargs rg --hidden --column --line-number --no-heading --color=always --with-filename -e '' ]]
        }
      end,
    }
    map {
      key = '<leader>fj',  desc = 'FZF js',
      cmd = function()
        require('fzf-lua').grep({prompt= 'JAVASCRIPT❯❯ ', search = ' -- app/assets/javascripts/**', fzf_opts = { ['--nth'] = '3..' }})
      end,
    }
    map {
      key = '<leader>fc',  desc = 'FZF css',
      cmd =  function() require('fzf-lua').grep({prompt= 'CSS❯❯ ', search = ' -- app/assets/stylesheets/**', fzf_opts = { ['--nth'] = '3..' }}) end,
    }
    map {
      key = '<leader>fh',  desc = 'FZF html',
      cmd = function()
        require('fzf-lua').grep({prompt= 'HTML❯❯ ', search = ' -- app/views/**', fzf_opts = { ['--nth'] = '3..' }})
      end,
    }

    map {
      key = '<leader>fq',  desc = 'Find files containing query',
      cmd = function()
        require('fzf-lua').live_grep_native({ rg_opts = '--files-with-matches --column --line-number', prompt= 'Find Files Containing❯❯ ', fzf_opts = { ['--nth'] = '1..' }})
      end,
    }
    map {
      key = '<leader>fr',   desc = 'FZF ruby (not spec)',
      cmd = function()
        require('fzf-lua').grep({prompt= 'RUBY❯❯ ', search = ' -- app/** !config/locales/** !*.yml* !app/assets/javascripts/** !app/views/** !app/assets/stylesheets/** !spec/**', fzf_opts = { ['--nth'] = '3..' }})
      end,
    }
    map {
      key = '<leader>fb',  desc = 'fuzzy find in buffer',
      cmd = function()
        require('fzf-lua').grep_curbuf({ previewer=false, winopts = { fullscreen = false, height=0.50,width=0.60,row=0.4,col=0.5 }})
      end,
    }
    map {
      key = '<leader>fB',  desc = 'fuzzy find in buffer',
      cmd = function()
        require('fzf-lua').lgrep_curbuf({fzf_opts = {['--layout']='reverse-list'}, winopts = { fullscreen = false, height=0.80,width=0.65,row=0.5,col=0.5 }})
      end,
    }
    map {
      key = '<leader>fl',  desc = 'Continue most recent search',
      cmd = function()
        require('fzf-lua').grep_last()
      end,
    }
    map {
      key = '<leader>f.',  desc = 'Grep word under cursor',
      cmd = function()
        require('fzf-lua').grep_cword()
      end,
    }
    map {
      key = '<leader>fW',  desc = 'Grep WORD  under cursor',
      cmd = function()
        require('fzf-lua').grep_cWORD()
      end,
    }
    map {
      key = '<leader>fv',  desc = 'Grep visual block',
      cmd = function()
        require('fzf-lua').grep_visual()
      end,
    }
    map {
      key = '<leader>bk',  desc = 'Show open buffers',
      cmd = function()
        require('fzf-lua').buffers({previewer=false, winopts = { fullscreen = false, height=0.40,width=0.5,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})
      end,
    }
    map {
      key = '<leader>fp',  desc = 'File Preview',
      cmd = function()
        require('fzf-lua').files()
      end,
    }
    map {
      key = '<leader>gc',  desc = 'open changes made to buffer',
      cmd = function() require('fzf-lua').changes() end,
    }
    map {
      key = '<leader>bl',  desc = '[o]pen buffer lines',
      cmd = function()
        require('fzf-lua').lines({previewer=false})
      end,
    }
    map {
      key = '<leader>qs',  desc = '[q]uickfix [s]tack',
      cmd = function() require('fzf-lua').quickfix_stack() end,
    }
    map {
      key = '<leader>qc',  desc = '[q]uickfix [c]lear',
      cmd = function() vim.fn.setqflist({}) end,
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
      cmd = function() require('fzf-lua').quickfix() end,
    }
    map {
      key = '<leader>ob',  desc = '[o]ld [b]uffers',
      cmd = function() require('fzf-lua').oldfiles() end,
    }
    map {
      key = '<leader>gs',  desc = 'fzf git status',
      cmd = function() require('fzf-lua').git_status( { prompt = 'Git Changes❯❯ '}) end,
    }
    map {
      key = '<leader>x',  desc = 'FZF builtins',
      cmd = function()
        require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})
      end,
    }

    require('fzf-lua').setup(require('custom.fzf_custom_opts'))
  end,
}

