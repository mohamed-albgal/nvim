return {
  "elanmed/fzf-lua-frecency.nvim",
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    require("fzf-lua-frecency").setup()
  end,
}
