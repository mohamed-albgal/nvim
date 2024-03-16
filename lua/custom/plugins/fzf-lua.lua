local fzf_opts = {

    'fzf-native',
  winopts = {
    height           = 0.85,            -- window height
    width            = 0.80,            -- window width
    row              = 0.35,            -- window row position (0=top, 1=bottom)
    col              = 0.50,            -- window col position (0=left, 1=right)
    border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    fullscreen       = false,           -- start fullscreen?
    preview = {
      border         = 'border',        -- border|noborder, applies only to
      wrap           = 'wrap',        -- wrap|nowrap
      hidden         = 'nohidden',      -- hidden|nohidden
      vertical       = 'down:45%',      -- up|down:size
      horizontal     = 'right:60%',     -- right|left:size
      layout         = 'flex',          -- horizontal|vertical|flex
      flip_columns   = 120,             -- #cols to switch to horizontal on flex
    },
  },
  fzf_opts = {

      ['--ansi']        = '',
      --['--info']        = 'inline',
      ['--height']      = '100%',
      ['--border']      = 'none',
      ['--layout']      = 'default',
      ['--delimiter']      = ':',
      -- ['--color'] = 'fg:#d9d9d9,bg:#001010,hl:#fff000,fg+:#49a6fd,bg+:#000000,hl+:#cecece,info:#afaf87,prompt:#d7005f,pointer:#afdfff,marker:#87ff00,spinner:#af5fff,header:#87afaf',
      ['--color'] = 'fg:#d9d9d9,hl:#fff000,fg+:#49a6fd,bg+:#000000,hl+:#49a6fd,info:#afaf87,prompt:#d7005f,pointer:#49a6fd,marker:#87ff00,spinner:#af5fff,header:#87afaf',
      ['--preview'] = { default = "bat" },
      ['--preview-window'] =  'nowrap,56%,+{2}+3/3,~3' ,
  },
  previewers = {
    bat = {
      args            = "--color=always --style=numbers,changes,header,grid ",
      theme           = '1337',
    },
  },
  files = { rg_opts = "--color=never --files --hidden --follow -g '!{**/node_modules/**,vendor/**,/config/initializers/rdebug.rb}'", prompt = 'FROGS!❯ ', },
  grep = {
    prompt            = '❯❯❯  ',
    input_prompt      = 'Grep For❯ ',
    multiprocess      = true,           -- run command in a separate process
    git_icons         = true,           -- show git icons?
    file_icons        = true,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
    rg_opts           = "--column --line-number --no-heading  -g '!{public/**,**/node_modules/**,vendor/**,**/config/initializers/** }' --color=always --smart-case --max-columns=4096 -e",
    -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
    -- search strings will be split using the 'glob_separator' and translated
    -- to '--iglob=' arguments, requires 'rg'
    -- can still be used when 'false' by calling 'live_grep_glob' directly
    rg_glob           = true,        -- default to glob parsing?
    glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
    glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
    -- advanced usage: for custom argument parsing define
    -- 'rg_glob_fn' to return a pair:
    --   first returned argument is the new search query
    --   second returned argument are addtional rg flags
    -- rg_glob_fn = function(query, opts)
    --   ...
    --   return new_query, flags
    -- end,
  },
  git = {
    -- status = { preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS delta --color-only --features=interactive" },
    bcommits = {
      prompt        = 'BUFFER_Commits❯ ',
      preview = "git show --color $(echo {1} | cut -d ' ' -f 1)"
    },
    commits = {
      prompt        = 'Commits❯❯❯ ',
      -- cmd           = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
      -- preview       = "git show --color -- {1}",

      preview = "git show --color $(echo {1} | cut -d ' ' -f 1)"
      -- git-delta is automatically detected as pager, uncomment to disable
      -- preview_pager = false,    }
    }
  }
}


return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    vim.keymap.set('n', '<leader>k', ":lua require('fzf-lua').files({ previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>ff', ":lua require('fzf-lua').grep_project({winopts = { height = 0.95, width = 0.95 }})<cr>", { silent = true, desc = 'FZF grep' })
    vim.keymap.set('n', '<leader>fF', ":lua require('fzf-lua').grep_project({ fzf_opts= { ['--nth']='1..'},winopts = { height = 0.95, width = 0.95 }})<cr>", { silent = true, desc = 'FZF grep, include path queries' })
    vim.keymap.set('n', '<leader>fk', ":lua require('fzf-lua').live_grep_native()<cr>", { silent = true, desc = 'Native live grep (more performant)' })
    vim.keymap.set('n', '<leader>fg', ":lua require('fzf-lua').live_grep_glob()<cr>", { silent = true, desc = 'Glob support' })

    vim.keymap.set('n', '<leader>fs', ":lua require('fzf-lua').grep({search = ' --*spec*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF specs' })
    vim.keymap.set('n', '<leader>fy', ":lua require('fzf-lua').grep({search = ' --*yml*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF specs' })
    vim.keymap.set('n', '<leader>fj', ":lua require('fzf-lua').grep({search = ' --*.js*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF js' })
    vim.keymap.set('n', '<leader>fc', ":lua require('fzf-lua').grep({search = ' --*.scss*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF css' })
    vim.keymap.set('n', '<leader>fh', ":lua require('fzf-lua').grep({search = ' --*.html*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF html' })
    vim.keymap.set('n', '<leader>fr', ":lua require('fzf-lua').grep({search = ' --*.rb*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF ruby' })

    vim.keymap.set('n', '<leader>fb', ":lua require('fzf-lua').grep_curbuf({previewer=false, winopts = { fullscreen = false, height=0.50,width=0.50,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'fuzzy find in buffer' })
    vim.keymap.set('n', '<leader>fB', ":lua require('fzf-lua').lgrep_curbuf({previewer=false,fzf_opts = {['--layout']='reverse-list'}, winopts = { fullscreen = false, height=0.50,width=0.65,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'fuzzy find in buffer' })
    vim.keymap.set('n', '<leader>fl', ":lua require('fzf-lua').grep_last()<cr>", { silent = true, desc = 'Continue most recent search' })
    vim.keymap.set('n', '<leader>f.', ":lua require('fzf-lua').grep_cword()<cr>", { silent = true, desc = 'Grep word under cursor' })
    vim.keymap.set('n', '<leader>fC', ":lua require('fzf-lua').grep_cWORD()<cr>", { silent = true, desc = 'Grep WORD  under cursor' })
    vim.keymap.set('n', '<leader>fv', ":lua require('fzf-lua').grep_visual()<cr>", { silent = true, desc = 'Grep visual block' })
    vim.keymap.set('n', '<leader>bk', ":lua require('fzf-lua').buffers({previewer=false, winopts = { fullscreen = false, height=0.40,width=0.5,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'Show open buffers' })
    vim.keymap.set('n', '<leader>fp', ":lua require('fzf-lua').files({winopts={ height=0.98, width=0.95}})<cr>", { silent = true, desc = 'File Preview' })

    vim.keymap.set('n', '<leader>gc', ":FzfLua changes<cr>", { silent = true, desc = 'open changes made to buffer' })
    vim.keymap.set('n', '<leader>bl', ":lua require('fzf-lua').lines({previewer=false})<cr>", { silent = true, desc = '[o]pen buffer lines' })
    vim.keymap.set('n', '<leader>qs', ":FzfLua quickfix_stack<cr>", { silent = true, desc = '[q]uickfix [s]tack' })
    vim.keymap.set('n', '<leader>qc', ":cexpr []<cr>", { silent = true, desc = '[q]uickfix [c]lear' })
    vim.keymap.set('n', '<leader>qn', ":cn<cr>", { silent = true, desc = 'next entry of quickfix list' })
    vim.keymap.set('n', '<leader>qp', ":cp<cr>", { silent = true, desc = 'previous entry of quickfix list' })
    vim.keymap.set('n', '<leader>qu', ":FzfLua quickfix<cr>", { silent = true, desc = '[qu]ick fix list' })
    vim.keymap.set('n', '<leader>ob', ":FzfLua oldfiles<cr>", { silent = true, desc = '[o]ld [b]uffers' })
    vim.keymap.set('n', '<leader>os', ":FzfLua search_history<cr>", { silent = true, desc = '[o]ld [s]earches' })

    vim.keymap.set('n', '<leader>gs', ":lua require('fzf-lua').git_status({winopts = { width=0.98,row=0.5,col=0.5} })<cr>", { silent = true, desc = 'fzf git status' })
    vim.keymap.set('n', '<leader>x', ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'FZF builtins' })
    vim.keymap.set("n", "<C-x><C-f>", function() require("fzf-lua").complete_path() end, { silent = true, desc = "Fuzzy complete path" })
    require('fzf-lua').setup(fzf_opts)
  end,
}

