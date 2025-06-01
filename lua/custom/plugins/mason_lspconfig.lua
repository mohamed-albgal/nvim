return {
  { "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
}

--nvim release 0.11+ could simplify things to not need mason-lspconfig, but found myself doing what mason-config and lsp-config did?
--like setting up config files for each language server, which felt redundant. plugins are not necessarily evil and lsp stuff is a good use of that
-- why have both lsp-config and mason-lspconfig? lsp-config is for the actual config of the language servers, while mason-lspconfig is for managing the installation of those servers. hopefully this will be simplified in the future?
