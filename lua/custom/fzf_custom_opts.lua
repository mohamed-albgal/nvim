-- this isnt working for some, come back at some point and debug
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

return {
    'telescope',
  winopts = {
    height           = 0.95,            -- window height
    width            = 0.98,            -- window width
    row              = 0.35,            -- window row position (0=top, 1=bottom)
    col              = 0.50,            -- window col position (0=left, 1=right)
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
      ['--color'] = table.concat({
        text_color .. white,               -- Normal text color
        highlight .. yellow,               -- Highlighted match color
        selected_highlight .. other_blue,  -- Highlighted match in selected item
        selected_text .. white,            -- Selected item text color
        selected_bg .. black,              -- Selected item background color
        pointer .. cyan                    -- Pointer color
      }, ',')
  },
  previewers = {
    bat = {
      args            = "--color=always --style=numbers,changes,header,grid ",
      theme           = '1337',
    },
  },
  files = { rg_opts = [[--color=never --hidden --files -g "!.git"]] },
  grep = {
    prompt            = '❯❯❯  ',
    input_prompt      = 'Grep For❯ ',
    multiprocess      = true,           -- run command in a separate process
    git_icons         = true,           -- show git icons?
    file_icons        = true,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
    rg_opts           = "--line-number --no-heading  -g '!{public/**,.git/,**/node_modules/**,vendor/**,config/initializers/** }' --no-column --color=always --colors 'column:fg:cyan'  --colors 'path:style:bold' --colors 'path:fg:blue' --colors 'line:fg:green' --colors 'match:fg:0xFF,0xFF,0x0' --smart-case --max-columns=4096 -e",
    rg_glob           = true,        -- default to glob parsing?
    glob_flag         = "--iglob",    -- for case sensitive globs use '--glob'
    glob_separator    = "%s%-%-",     -- query separator pattern (lua): ' --'
    actions = {
      ["ctrl-o"]      = { require('fzf-lua').actions.grep_lgrep }
    },
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

