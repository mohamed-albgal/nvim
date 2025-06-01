return {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 160,
        options = {
          number = false,
        }
      },
      on_open = function()
        vim.fn.system('kitty @ set-tab-bar visible no')
      end,
      on_close = function()
        vim.fn.system('kitty @ set-tab-bar visible yes')
      end,
    }
  }
