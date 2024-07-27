return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }, 
  keys = { { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" },
           { "<leader>es", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Nvim Tree find in tree" },
           { "<leader>ey", "<cmd>NvimTreeClipboard<cr>", desc = "Nvim Tree Clipboard" }
        },

  config = function()
    require("nvim-tree").setup {}
  end,
}

