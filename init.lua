--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- set up vscode seperately
if vim.fn.exists("g:vscode") ~= 0 then
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.clipboard = 'unnamedplus'
  vim.keymap.set({ 'n', 'v' }, '<leader>', "<cmd>call VSCodeNotify('whichkey.show')<CR>")
  vim.keymap.set('n', 'gD', "<cmd>call VSCodeNotify('editor.action.revealDefinitionAside')<CR>")
  require('lazy').setup({
    { 'ggandor/lightspeed.nvim' },
  })
else
  -- NOTE: Here is where you install your plugins.
  --  You can configure plugins using the `config` key.
  --
  --  You can also configure plugins after the setup call,
  --    as they will be available in your neovim runtime.
  require('custom.keys')
  vim.o.ignorecase = true
  vim.o.smartcase = true

  require('lazy').setup({
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
      -- LSP Configuration & Plugins
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim',          config = true },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim',                tag = 'legacy', opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
      },
    },

    {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',

        -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets',
      },
    },
    { "catppuccin/nvim",               name = "catppuccin", priority = 1000 },
    { 'ntpeters/vim-better-whitespace' },

    {
      -- Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        -- See `:help gitsigns.txtissi`
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[G]itSigns [R]eset Hunk' })
          vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
          vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
          vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk_inline, { buffer = bufnr, desc = '[P]review [H]unk' })
        end,
      },
    },
    -- Add indentation guides even on blank lines
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    -- { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
    --    up-to-date with whatever is in the kickstart repo.
    --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
    { import = 'custom.plugins' },
  }, {})
  require('custom.setup_config')
  require 'luasnip'.filetype_extend("ruby", { "rails" })

  -- [[ Setting options ]]
  -- See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  vim.opt.termguicolors = true
  -- for tabline
  -- require("bufferline").setup {}
  -- require("ibl").setup()
  -- local highlight = {
  --     -- "CursorColumn",
  --     "Whitespace",
  -- }
  -- require("ibl").setup {
  --     indent = { highlight = highlight, char = "" },
  --     whitespace = {
  --         highlight = highlight,
  --         remove_blankline_trail = false,
  --     },
  --     scope = { enabled = false },
  -- }
  --

  -- Set highlight on search
  vim.o.hlsearch = true

  -- Make line numbers default
  vim.wo.number = false

  -- enable mouse mode
  vim.o.mouse = 'a'
  --
  -- set timeoutlen
  vim.o.timeoutlen = 550


  -- Sync clipboard between OS and Neovim.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.o.clipboard = 'unnamedplus'

  -- Enable break indent
  vim.o.breakindent = true
  vim.o.shiftwidth = 2
  vim.o.tabstop = 2
  vim.o.softtabstop = 2
  vim.o.cindent = true
  vim.o.expandtab = true
  vim.o.smartindent = true

  -- Save undo history
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.wo.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250
  --vim.o.timeoutlen = 300

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- NOTE: You should make sure your terminal supports this
  vim.o.termguicolors = true

  -- [[ Basic Keymaps ]]

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  -- [[ Configure Treesitter ]]
  -- See `:help nvim-treesitter`

  require('nvim-treesitter.configs').setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'lua', 'python', 'javascript', 'tsx', 'typescript', 'ruby', 'vimdoc', 'vim', 'html' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>pa'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>pA'] = '@parameter.inner',
        },
      },
    },
  })

  -- Define custom diagnostic signs
  vim.fn.sign_define('DiagnosticSignError', { text = 'E', texthl = 'DiagnosticSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

  -- Diagnostics configuration
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
  })
  -- keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

  -- [[ Configure LSP ]]
  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>bs', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('fzf-lua').lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>bf', vim.lsp.buf.format, '[b]uffer [F]efinition')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>Wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. They will be passed to
  --  the `settings` field of the server config. You must look up that documentation yourself.
  --
  --  If you want to override the default filetypes that your language server will attach to you can
  --  define the property 'filetypes' to the map in question.
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    ts_ls = {},
    ruby_lsp = {
      settings = {
        rubyLsp = {
          formatter = "rubocop"
        }
      }
    },
    -- solargraph = {
    --   filetypes = { 'ruby' },
    --   settings = {
    --     solargraph = {
    --       diagnostics = true,
    --       completion = true,
    --       definitions = true,
    --       hover = true,
    --       references = true,
    --       rename = true,
    --       symbols = true,
    --       formatting = true,
    --     },
    --   },
    -- },
    eslint = {},
    html = { filetypes = { 'html', 'erb' } },

    lua_ls = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  }

  -- Setup neovim lua configuration
  require('neodev').setup()

  -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

  -- Ensure the servers above are installed
  local mason_lspconfig = require 'mason-lspconfig'

  mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
  }

  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
        root_dir = function() return vim.loop.cwd() end
      }
    end
  }

  -- show row line in active window
  -- local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
  -- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, { pattern = "*", command = "set cursorline", group = cursorGrp })
  -- vim.api.nvim_create_autocmd(
  --   { "InsertEnter", "WinLeave" },
  --   { pattern = "*", command = "set nocursorline", group = cursorGrp }
  -- )

  --
  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  require('luasnip.loaders.from_vscode').lazy_load({ path = { "~/.config/nvim/console.code-snippets" } })
  luasnip.config.setup {}

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-k>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete {},
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },

      ['<Tab>'] = cmp.mapping(function(fallback)
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }
end -- end of if/else for vscode vs neovim

-- The line beneath this is called `modeline`. See `:help modeline`
--
-- vim: ts=2 sts=2 sw=2 et
