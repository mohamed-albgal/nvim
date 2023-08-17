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
      ['--color'] = 'fg:#d9d9d9,bg:#001010,hl:#fff000,fg+:#49a6fd,bg+:#000000,hl+:#cecece,info:#afaf87,prompt:#d7005f,pointer:#afdfff,marker:#87ff00,spinner:#af5fff,header:#87afaf',
      ['--preview'] = { default = "bat" },
      ['--preview-window'] =  'nowrap,56%,+{2}+3/3,~3' ,
  },
  previewers = {
    bat = {
      cmd             = "bat",
      args            = "--color=always --style=numbers,changes,header,grid ",
      theme           = '1337',
    },
  },
  files = { previewer = false, rg_opts           = "--color=never --files --hidden --follow -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}'", prompt            = 'Files❯ ', },
  grep = {
    rg_opts =  "--column --line-number --no-heading  -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}' --color=always --smart-case --max-columns=4096 -e",
    prompt            = '❯ ',
    input_prompt      = 'Grep For❯ ',
    multiprocess      = true,           -- run command in a separate process
    git_icons         = true,           -- show git icons?
    file_icons        = true,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
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
}

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    vim.keymap.set('n', '<leader>k', ":lua require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:45%', height=0.50,width=0.55,row=0.09,col=0.47,  }, })<cr>", { silent = true, desc = 'FZF Files' })
    -- vim.keymap.set('n', '<leader>k', ":lua require('fzf-lua').files({ cmd = '--column --line-number --no-heading  -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}' --color=always --smart-case --max-columns=4096 -e' })<cr>", { silent = true, desc = 'FZF Files' })

    -- this works but is too hacky! the old stuff would work, maybe go slow?
    --vim.keymap.set('n', '<leader>ff', "[[:lua require'fzf-lua'.fzf_exec(\"rg --column --line-number -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}' --no-heading  -- ''\",{ fzf_opts = {['--layout']= 'default', ['--preview'] = vim.fn.shellescape(\"bat -f --highlight-line={2} {1} --theme='1337'\"), ['--preview'] = \"--border -m --color=fg:#d9d9d9,bg:#000000,hl:#fff000 --color=fg+:#49a6fd,bg+:#000000,hl+:#ffffff  --color=info:#afaf87,prompt:#d7005f,pointer:#afdfff --color=marker:#87ff00,spinner:#af5fff,header:#87afaf --preview-window 'wrap,56%,+{2}+3/3,~3'\", ['--delimiter'] = ':', ['--preview-window'] = 'nohidden,56%', }, }) <cr>]]", { silent = true, desc = 'FZF grep' })

    vim.keymap.set('n', '<leader>ff', ":lua require('fzf-lua').grep_project({winopts = { height = 0.95, width = 0.95 }})<cr>", { silent = true, desc = 'FZF grep' })
    vim.keymap.set('n', '<leader>fk', ":lua require('fzf-lua').live_grep_native()<cr>", { silent = true, desc = 'Native live grep (more performant)' })
    vim.keymap.set('n', '<leader>fs', ":lua require('fzf-lua').live_grep_glob()<cr>", { silent = true, desc = 'Glob support' })
    vim.keymap.set('n', '<leader>fb', ":lua require('fzf-lua').grep_curbuf({fzf_opts = {['--no-sort'] = ''}})<cr>", { silent = true, desc = 'fuzzy find in buffer' })
    vim.keymap.set('n', '<leader>fl', ":lua require('fzf-lua').grep_last()<cr>", { silent = true, desc = 'Continue most recent search' })
    vim.keymap.set('n', '<leader>f.', ":lua require('fzf-lua').grep_cword()<cr>", { silent = true, desc = 'Grep word under cursor' })
    vim.keymap.set('n', '<leader>fC', ":lua require('fzf-lua').grep_cWORD()<cr>", { silent = true, desc = 'Grep WORD  under cursor' })
    vim.keymap.set('n', '<leader>fv', ":lua require('fzf-lua').grep_visual()<cr>", { silent = true, desc = 'Grep visual block' })
    vim.keymap.set('n', '<leader>bb', ":FzfLua buffers<cr>", { silent = true, desc = 'Show open buffers' })
    vim.keymap.set('n', '<leader>ob', ":FzfLua oldfiles<cr>", { silent = true, desc = '[o]ld [b]uffers' })
    vim.keymap.set('n', '<leader>os', ":FzfLua search_history<cr>", { silent = true, desc = '[o]ld [s]earches' })
    vim.keymap.set('n', '<leader>gs', ":lua require('fzf-lua').git_status()<cr>", { silent = true, desc = 'fzf git status' })
    vim.keymap.set('n', '<leader>x', ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'FZF builtins' })
    vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function() require("fzf-lua").complete_path() end, { silent = true, desc = "Fuzzy complete path" })
    require('fzf-lua').setup(fzf_opts)
  end,
}




--  fzf_opts = {
  -- ['--layout'] = 'default',
  -- ['--delimiter'] = ':',
  -- ['--preview-window'] = 'nohidden,56%', }, 










