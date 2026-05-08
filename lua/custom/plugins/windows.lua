return  { "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim"
  },
  config = function()
    vim.o.winwidth = 19
    vim.o.winminwidth = 19
    vim.o.equalalways = false

    -- windows.nvim treats "preview" windows as non-floating based on win_gettype(),
    -- but Oil opens preview windows as floating editor-relative windows.
    require("windows.lib.api").Window.is_floating = function(self)
      return vim.api.nvim_win_get_config(self.id).relative ~= ""
    end

    require('windows').setup({
      animation = { duration = 250 }
    })
  end
}
