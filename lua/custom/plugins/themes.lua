return {

  { "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },

  { "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
    end,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
