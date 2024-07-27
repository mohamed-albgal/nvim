local white = '#ffffff'
local black = '#000000'
local other_blue = '#49a6fd'
local yellow = '#ffff00'
local text_color = 'fg:'
local highlight = 'hl:'
local selected_highlight = 'hl+:'
local selected_text = 'fg+:'
local selected_bg = 'bg+:'
local pointer = 'pointer:'
local cyan = '#00ffff'
local color_string = table.concat({
  text_color .. white,
  -- bg .. black,
  highlight .. yellow,
  selected_text .. yellow,
  selected_bg .. black,
  pointer .. cyan,
  selected_highlight .. other_blue,
}, ',')

local fzf_table_opts = {

    'telescope',
  winopts = {
    height           = 0.9,            -- window height
    width            = 0.75,            -- window width
    row              = 0.35,            -- window row position (0=top, 1=bottom)
    col              = 0.50,            -- window col position (0=left, 1=right)
    border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    fullscreen       = false,           -- start fullscreen?
    preview = {
      border         = 'border',        -- border|noborder, applies only to
      wrap           = 'wrap',        -- wrap|nowrap
      hidden         = 'nohidden',      -- hidden|nohidden
      vertical       = 'up:68%',      -- up|down:size
      horizontal     = 'right:68%',     -- right|left:size
      layout         = 'vertical',          -- horizontal|vertical|flex
      flip_columns   = 120,             -- #cols to switch to horizontal on flex
    },
  },
  fzf_opts = {
      ['--ansi']        = '',
      ['--info']        = 'default',
      ['--height']      = '100%',
      ['--layout']      = 'default',
      ['--pointer']     = '❯',
      ['--marker']      = '❯ ',
      ['--delimiter']      = ':',
      ['--color'] =  color_string
  },
  previewers = {
    bat = {
      args            = "--color=always --style=numbers,changes,header,grid ",
      theme           = '1337',
    },
  },
  files = { rg_opts = "--color=never --files --hidden --follow -g '!{**/node_modules/**,vendor/**,/config/initializers/**}'", prompt = 'FROGS!❯ ', },
  grep = {
    prompt            = '❯❯❯  ',
    input_prompt      = 'Grep For❯ ',
    multiprocess      = true,           -- run command in a separate process
    git_icons         = true,           -- show git icons?
    file_icons        = true,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
    rg_opts           = "--column --line-number --no-heading  -g '!{public/**,**/node_modules/**,vendor/**,config/initializers/** }' --no-column --color=always --colors 'column:fg:cyan'  --colors 'path:style:bold' --colors 'path:fg:blue' --colors 'line:fg:green' --colors 'match:fg:0xFF,0xFF,0x0' --smart-case --max-columns=4096 -e",
    rg_glob           = true,        -- default to glob parsing?
    glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
    glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
  },
  git = {
    bcommits = {
      prompt        = 'BUFFER_Commits❯ ',
      preview = "git show --color $(echo {1} | cut -d ' ' -f 1)"
    },
    commits = {
      prompt        = 'Commits❯❯❯ ',

      preview = "git show --color $(echo {1} | cut -d ' ' -f 1)"
    }
  }
}


return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    -- Finding Files
    vim.keymap.set('n', '<leader>k', ":lua require('fzf-lua').files({ previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>ic', ":lua require('fzf-lua').files({cwd='app/assets/stylesheets', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>ij', ":lua require('fzf-lua').files({cwd='app/assets/javascripts', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>is', ":lua require('fzf-lua').files({cwd='spec/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>iy', ":lua require('fzf-lua').files({cwd='config/locales/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })
    vim.keymap.set('n', '<leader>ih', ":lua require('fzf-lua').files({cwd='app/views/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>", { silent = true, desc = 'FZF Files' })


    -- Grepping in Files
    vim.keymap.set('n', '<leader>ff', ":lua require('fzf-lua').grep_project()<cr>", { silent = true, desc = 'FZF grep' })
    vim.keymap.set('n', '<leader>fF', ":lua require('fzf-lua').grep_project({ prompt = 'RAW❯❯ ', fzf_opts= { ['--nth']='1..'})<cr>", { silent = true, desc = 'FZF grep, include path queries' })
    vim.keymap.set('n', '<leader>fK', ":lua require('fzf-lua').live_grep_native({ prompt = 'rg❯❯ '})<cr>", { silent = true, desc = 'Native live grep (more performant)' })
    vim.keymap.set('n', '<leader>fk', ":lua require('fzf-lua').live_grep_glob({ prompt = '❯❯ '})<cr>", { silent = true, desc = 'Glob support' })
    vim.keymap.set('n', '<leader>fs', ":lua require('fzf-lua').grep({prompt= 'SPECS❯❯ ', search = ' -- spec/** !*fixtures*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF specs' })
    vim.keymap.set('n', '<leader>fy', ":lua require('fzf-lua').grep({prompt= 'YAML❯❯ ', search = ' -- config/locales/** *.yml*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF specs' })
    vim.keymap.set('n', '<leader>fd', ":lua require('fzf-lua').grep({previewer=false, winopts={height=0.3,width=0.3}, prompt= '❯  ', search = 'debugger -- !*config*', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF specs' })
    vim.keymap.set('n', '<leader>fj', ":lua require('fzf-lua').grep({prompt= 'JAVASCRIPT❯❯ ', search = ' -- app/assets/javascripts/**', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF js' })
    vim.keymap.set('n', '<leader>fc', ":lua require('fzf-lua').grep({prompt= 'CSS❯❯ ', search = ' -- app/assets/stylesheets/**', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF css' })
    vim.keymap.set('n', '<leader>fh', ":lua require('fzf-lua').grep({prompt= 'HTML❯❯ ', search = ' -- app/views/**', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF html' })
    vim.keymap.set('n', '<leader>fr', ":lua require('fzf-lua').grep({prompt= 'RUBY❯❯ ', search = ' -- app/** !config/locales/** !*.yml* !app/assets/javascripts/** !app/views/** !app/assets/stylesheets/** !spec/**', fzf_opts = { ['--nth'] = '1..' }})<cr>", { silent = true, desc = 'FZF ruby (not spec)' })

    vim.keymap.set('n', '<leader>fb', ":lua require('fzf-lua').grep_curbuf({ previewer=false, winopts = { fullscreen = false, height=0.50,width=0.60,row=0.4,col=0.5 }})<cr>", { silent = true, desc = 'fuzzy find in buffer' })
    vim.keymap.set('n', '<leader>fB', ":lua require('fzf-lua').lgrep_curbuf({previewer=false,fzf_opts = {['--layout']='reverse-list'}, winopts = { fullscreen = false, height=0.50,width=0.65,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'fuzzy find in buffer' })
    vim.keymap.set('n', '<leader>fl', ":lua require('fzf-lua').grep_last()<cr>", { silent = true, desc = 'Continue most recent search' })
    vim.keymap.set('n', '<leader>f.', ":lua require('fzf-lua').grep_cword()<cr>", { silent = true, desc = 'Grep word under cursor' })
    vim.keymap.set('n', '<leader>fC', ":lua require('fzf-lua').grep_cWORD()<cr>", { silent = true, desc = 'Grep WORD  under cursor' })
    vim.keymap.set('n', '<leader>fv', ":lua require('fzf-lua').grep_visual()<cr>", { silent = true, desc = 'Grep visual block' })
    vim.keymap.set('n', '<leader>bk', ":lua require('fzf-lua').buffers({previewer=false, winopts = { fullscreen = false, height=0.40,width=0.5,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'Show open buffers' })
    vim.keymap.set('n', '<leader>fp', ":lua require('fzf-lua').files()<cr>", { silent = true, desc = 'File Preview' })

    vim.keymap.set('n', '<leader>gc', ":FzfLua changes<cr>", { silent = true, desc = 'open changes made to buffer' })
    vim.keymap.set('n', '<leader>bl', ":lua require('fzf-lua').lines({previewer=false})<cr>", { silent = true, desc = '[o]pen buffer lines' })

    vim.keymap.set('n', '<leader>qs', ":FzfLua quickfix_stack<cr>", { silent = true, desc = '[q]uickfix [s]tack' })
    vim.keymap.set('n', '<leader>qc', ":cexpr []<cr>", { silent = true, desc = '[q]uickfix [c]lear' })
    vim.keymap.set('n', '<leader>qn', ":cn<cr>", { silent = true, desc = 'next entry of quickfix list' })
    vim.keymap.set('n', '<leader>qp', ":cp<cr>", { silent = true, desc = 'previous entry of quickfix list' })
    vim.keymap.set('n', '<leader>qu', ":FzfLua quickfix<cr>", { silent = true, desc = '[qu]ick fix list' })
    vim.keymap.set('n', '<leader>ob', ":FzfLua oldfiles<cr>", { silent = true, desc = '[o]ld [b]uffers' })
    vim.keymap.set('n', '<leader>os', ":FzfLua search_history<cr>", { silent = true, desc = '[o]ld [s]earches' })

    vim.keymap.set('n', '<leader>gs', ":lua require('fzf-lua').git_status()<cr>", { silent = true, desc = 'fzf git status' })
    vim.keymap.set('n', '<leader>x', ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'FZF builtins' })
    vim.keymap.set("n", "<C-x><C-f>", function() require("fzf-lua").complete_path() end, { silent = true, desc = "Fuzzy complete path" })
    require('fzf-lua').setup(fzf_table_opts)
  end,
}

