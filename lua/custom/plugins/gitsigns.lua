
local ff = function(f, arg)
  return function()
    f(arg)
  end
end
return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    -- See `:help gitsigns.txtissi`
    signs = {
      add = { text = '✚' },
      change = { text = '〜' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      vim.keymap.set('n', '<leader>gn', ff(gs.nav_hunk, 'next'), { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
      vim.keymap.set('n', '<leader>gp', ff(gs.nav_hunk, 'prev'), { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
      vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { buffer = bufnr, desc = '[G]itSigns [R]eset Hunk' })
      vim.keymap.set('n', '<leader>gh', gs.preview_hunk_inline, { buffer = bufnr, desc = '[P]review [H]unk' })
    end,
  },
}
