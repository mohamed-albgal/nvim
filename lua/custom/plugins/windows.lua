return  { "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim"
  },
  config = function()
    vim.o.winwidth = 19
    vim.o.winminwidth = 19
    vim.o.equalalways = false
    require('windows').setup({
      animation = { duration = 250 }
    })
  end
}
