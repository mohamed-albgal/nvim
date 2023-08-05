local fzf_opts =
  {
    'default',
    fzf_opts = {
      ['--ansi']        = '',
      --['--info']        = 'inline',
      ['--height']      = '100%',
      ['--border']      = 'none',
      ['--layout']      = 'default',
      ['--delimiter']      = ':',
      ['--color'] = 'fg:#d9d9d9,bg:#001010,hl:#fff000,fg+:#49a6fd,bg+:#000000,hl+:#cecece,info:#afaf87,prompt:#d7005f,pointer:#afdfff,marker:#87ff00,spinner:#af5fff,header:#87afaf',
      ['--preview'] = { default = "bat" },
      ['--preview-window'] =  'nowrap,56%',
    },
    winopts = {
      --fullscreen = true,
      height=0.75,
      width=0.75,
    },
    files = {
      previewer = false,
      rg_opts           = "--color=never --files --hidden --follow -g '!.git' -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}'",
    },
    grep = {
      rg_opts =  "--column --line-number --no-heading  -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}' --color=always --smart-case --max-columns=4096 -e",
    },
}

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('fzf-lua').setup(fzf_opts)

    vim.keymap.set('n', '<leader>k', ":lua require('fzf-lua').files({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:45%', height=0.50,width=0.55,row=0.09,col=0.47,  } })<cr>", { silent = true, desc = 'FZF Files' })

    -- this works but is too hacky! the old stuff would work, maybe go slow?
    --vim.keymap.set('n', '<leader>ff', "[[:lua require'fzf-lua'.fzf_exec(\"rg --column --line-number -g '!{**/node_modules/**,**/vendor/**,**/config/initializers/rdebug.rb,**/vendor/assets/**}' --no-heading  -- ''\",{ fzf_opts = {['--layout']= 'default', ['--preview'] = vim.fn.shellescape(\"bat -f --highlight-line={2} {1} --theme='1337'\"), ['--preview'] = \"--border -m --color=fg:#d9d9d9,bg:#000000,hl:#fff000 --color=fg+:#49a6fd,bg+:#000000,hl+:#ffffff  --color=info:#afaf87,prompt:#d7005f,pointer:#afdfff --color=marker:#87ff00,spinner:#af5fff,header:#87afaf --preview-window 'wrap,56%,+{2}+3/3,~3'\", ['--delimiter'] = ':', ['--preview-window'] = 'nohidden,56%', }, }) <cr>]]", { silent = true, desc = 'FZF grep' })

    vim.keymap.set('n', '<leader>ff', ":lua require('fzf-lua').grep_project({winopts = { fullscreen = true}})<cr>", { silent = true, desc = 'FZF grep' })
    vim.keymap.set('n', '<leader>fk', ":lua require('fzf-lua').live_grep_native()<cr>", { silent = true, desc = 'Native live grep (more performant)' })
    vim.keymap.set('n', '<leader>fs', ":lua require('fzf-lua').live_grep_glob()<cr>", { silent = true, desc = 'Glob support' })
    vim.keymap.set('n', '<leader>fb', ":lua require('fzf-lua').lgrep_curbuf()<cr>", { silent = true, desc = 'Current buffer' })
    vim.keymap.set('n', '<leader>fc', ":lua require('fzf-lua').grep_last()<cr>", { silent = true, desc = 'Continue most recent search' })
    vim.keymap.set('n', '<leader>x', ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>", { silent = true, desc = 'FZF builtins' })
  end,
}




--  fzf_opts = {
  -- ['--layout'] = 'default',
  -- ['--delimiter'] = ':',
  -- ['--preview-window'] = 'nohidden,56%', }, 










