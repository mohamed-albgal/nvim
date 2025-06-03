return {
  { "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = true,
          inverse = {
            match_paren  = true,
            search       = true,
            search_count = true,
            visual       = true,
          },
        },
      })
      -- vim.cmd [[colorscheme nightfox]]
    end,
  },
}
