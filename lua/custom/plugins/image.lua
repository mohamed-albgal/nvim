return {
  { "3rd/image.nvim",
    dependencies = { "vhyrro/luarocks.nvim" },
    config = function()
      require('image').setup()
    end
  },
}
