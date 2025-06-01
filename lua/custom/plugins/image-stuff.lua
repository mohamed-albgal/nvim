return {
  {"vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" }
    }
  },

  { "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    config = function()
      require('image').setup()
    end
  },
}
