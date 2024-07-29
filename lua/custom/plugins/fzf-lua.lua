local function map(arg)
  vim.api.nvim_set_keymap(arg.mode or 'n', arg.key, arg.cmd, { noremap = true, silent = true, desc = arg.desc })
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()

    map{ key = '<leader>k',
      cmd = ":lua require('fzf-lua').files({ previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>ic',
      cmd = ":lua require('fzf-lua').files({cwd='app/assets/stylesheets', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>ij',
      cmd = ":lua require('fzf-lua').files({cwd='app/assets/javascripts', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>is',
      cmd = ":lua require('fzf-lua').files({cwd='spec/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>iy',
      cmd = ":lua require('fzf-lua').files({cwd='config/locales/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>ih',
      cmd = ":lua require('fzf-lua').files({cwd='app/views/', previewer=false, fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen=false, vertical = 'down:25%', height=0.50,width=0.35,row=0.09,col=0.47 }})<cr>",
      desc = 'FZF Files' }
    map{ key = '<leader>ff',
      cmd = ":lua require('fzf-lua').grep_project()<cr>",
      desc = 'FZF grep' }
    map{ key = '<leader>fF',
      cmd = ":lua require('fzf-lua').grep_project({ prompt = 'RAW❯❯ ', fzf_opts= { ['--nth']='1..'})<cr>",
      desc = 'FZF grep, include path queries' }
    map{ key = '<leader>fK',
      cmd = ":lua require('fzf-lua').live_grep_native({ prompt = 'rg❯❯ '})<cr>",
      desc = 'Native live grep (more performant)' }
    map{ key = '<leader>fk',
      cmd = ":lua require('fzf-lua').live_grep_glob({ prompt = '❯❯ '})<cr>",
      desc = 'Glob support' }
    map{ key = '<leader>fs',
      cmd = ":lua require('fzf-lua').grep({prompt= 'SPECS❯❯ ', search = ' -- spec/** !*fixtures*', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF specs' }
    map{ key = '<leader>fy',
      cmd = ":lua require('fzf-lua').grep({prompt= 'YAML❯❯ ', search = ' -- config/locales/** *.yml*', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF specs' }
    map{ key = '<leader>fd',
      cmd = ":lua require('fzf-lua').grep({previewer=false, winopts={height=0.3,width=0.3}, prompt= '❯  ', search = 'debugger -- !*config*', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF specs' }
    map{ key = '<leader>fj',
      cmd = ":lua require('fzf-lua').grep({prompt= 'JAVASCRIPT❯❯ ', search = ' -- app/assets/javascripts/**', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF js' }
    map{ key = '<leader>fc',
      cmd = ":lua require('fzf-lua').grep({prompt= 'CSS❯❯ ', search = ' -- app/assets/stylesheets/**', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF css' }
    map{ key = '<leader>fh',
      cmd = ":lua require('fzf-lua').grep({prompt= 'HTML❯❯ ', search = ' -- app/views/**', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF html' }
    map{ key = '<leader>fr',
      cmd = ":lua require('fzf-lua').grep({prompt= 'RUBY❯❯ ', search = ' -- app/** !config/locales/** !*.yml* !app/assets/javascripts/** !app/views/** !app/assets/stylesheets/** !spec/**', fzf_opts = { ['--nth'] = '1..' }})<cr>",
      desc = 'FZF ruby (not spec)' }
    map{ key = '<leader>fb',
      cmd = ":lua require('fzf-lua').grep_curbuf({ previewer=false, winopts = { fullscreen = false, height=0.50,width=0.60,row=0.4,col=0.5 }})<cr>",
      desc = 'fuzzy find in buffer' }
    map{ key = '<leader>fB',
      cmd = ":lua require('fzf-lua').lgrep_curbuf({previewer=false,fzf_opts = {['--layout']='reverse-list'}, winopts = { fullscreen = false, height=0.50,width=0.65,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>",
      desc = 'fuzzy find in buffer' }
    map{ key = '<leader>fl',
      cmd = ":lua require('fzf-lua').grep_last()<cr>",
      desc = 'Continue most recent search' }
    map{ key = '<leader>f.',
      cmd = ":lua require('fzf-lua').grep_cword()<cr>",
      desc = 'Grep word under cursor' }
    map{ key = '<leader>fC',
      cmd = ":lua require('fzf-lua').grep_cWORD()<cr>",
      desc = 'Grep WORD  under cursor' }
    map{ key = '<leader>fv',
      cmd = ":lua require('fzf-lua').grep_visual()<cr>",
      desc = 'Grep visual block' }
    map{ key = '<leader>bk',
      cmd = ":lua require('fzf-lua').buffers({previewer=false, winopts = { fullscreen = false, height=0.40,width=0.5,row=0.5,col=0.5, preview = { hidden = 'hidden' } }})<cr>",
      desc = 'Show open buffers' }
    map{ key = '<leader>fp',
      cmd = ":lua require('fzf-lua').files()<cr>",
      desc = 'File Preview' }
    map{ key = '<leader>gc',
      cmd = ":FzfLua changes<cr>",
      desc = 'open changes made to buffer' }
    map{ key = '<leader>bl',
      cmd = ":lua require('fzf-lua').lines({previewer=false})<cr>",
      desc = '[o]pen buffer lines' }
    map{ key = '<leader>qs',
      cmd = ":FzfLua quickfix_stack<cr>",
      desc = '[q]uickfix [s]tack' }
    map{ key = '<leader>qc',
      cmd = ":cexpr []<cr>",
      desc = '[q]uickfix [c]lear' }
    map{ key = '<leader>qn',
      cmd = ":cn<cr>",
      desc = 'next entry of quickfix list' }
    map{ key = '<leader>qp',
      cmd = ":cp<cr>",
      desc = 'previous entry of quickfix list' }
    map{ key = '<leader>qu',
      cmd = ":FzfLua quickfix<cr>",
      desc = '[qu]ick fix list' }
    map{ key = '<leader>ob',
      cmd = ":FzfLua oldfiles<cr>",
      desc = '[o]ld [b]uffers' }
    map{ key = '<leader>os',
      cmd = ":FzfLua search_history<cr>",
      desc = '[o]ld [s]earches' }
    map{key = '<leader>gs',
      cmd = ":lua require('fzf-lua').git_status()<cr>",
      desc = 'fzf git status' }
    map{ key = '<leader>x',
      cmd = ":lua require('fzf-lua').builtin({ fzf_opts = {['--layout'] = 'reverse'}, winopts = { fullscreen = false, height=0.50,width=0.45,row=0.09,col=0.47, preview = { hidden = 'hidden' } }})<cr>",
      desc = 'FZF builtins' }

    require('fzf-lua').setup(require('custom.fzf_custom_opts'))
  end,
}

