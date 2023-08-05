return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }, 
  keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" } },
  config = function()
    require("nvim-tree").setup {}
  end,
}

