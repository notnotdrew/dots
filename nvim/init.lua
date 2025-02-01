-- Variables
-- ------------------

vim.g.have_nerd_font = true -- Use an installed Nerd Font from terminal


-- Options
-- --------------

vim.opt.background = "dark" -- Set dark background (works with many colorschemes)
vim.opt.colorcolumn = "79" -- Show vertical column
vim.opt.completeopt = "menuone,noselect" -- [TRIAL] Set completeopt to have a better completion experience
vim.opt.cursorline = true -- Highlight current line
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.hidden = true -- Keep unsaved buffers open when switching files
vim.opt.history = 100 -- Keep command history (e.g., last 100 commands)
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.incsearch = true -- Highlight matches as you type (without persisting)
vim.opt.laststatus = 2 -- Always show the status line (2 = always visible)
vim.opt.list = true -- Show invisible chars
vim.opt.listchars = "tab:»·,trail:·" -- Show tabs and trailing whitespace only
vim.opt.number = true -- Show line numbers
vim.opt.scrolloff = 3 -- Always show 3 lines around cursor
vim.opt.shiftwidth = 2 -- Indent by 2 spaces when using ">" or auto-indent
vim.opt.showmatch = true -- Show matching parentheses
vim.opt.smartcase = true -- Turn case sensitive search back on in certain cases
vim.opt.smartindent = true -- Enable smarter auto-indentation
vim.opt.suffixesadd:append({ ".coffee", ".js", ".json", ".jsx", ".rb" }) -- Append these extensions for `gf` (go to file)
vim.opt.tabstop = 2 -- Set tab width to 2 spaces
vim.opt.termguicolors = true -- Enables 24-bit RGB color
vim.opt.wrap = false -- Disable line wrapping
vim.wo.signcolumn = "yes" -- Always show signcolumn


-- Commands
-- ----------------

vim.cmd([[
command W w
command Q q
command Vsp vsp
]])


-- Keymaps
-- --------------

-- Bind "K" to search for the word under the cursor using 'grep' and show results in the quickfix window
vim.keymap.set("n", "K", ':grep! "\\b<C-R><C-W>\\b"<CR>:cw<CR>', { silent = true })

-- Delete file
vim.keymap.set("n", "<leader>D", ":call delete(expand('%')) | bdelete!<CR>", { silent = true })

-- Edit file
vim.keymap.set("n", "<Leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { silent = true })

-- Read file
vim.keymap.set("n", "<Leader>r", ":r <C-R>=expand('%:p:h') . '/'<CR>", { silent = true })


-- Autocommands
-- ------------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Plugins
-- --------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'DataWraith/auto_mkdir', -- Save files into directories that do not exist yet
  'RRethy/vim-illuminate', -- Highlight other uses of the word under the cursor
  'andrewradev/splitjoin.vim', -- Switch between single-line and multiline forms of code
  'bronson/vim-trailing-whitespace', -- Highlights trailing whitespace in red
  'ervandew/supertab', -- Insert mode completions with Tab
  'hrsh7th/cmp-nvim-lsp', -- nvim-cmp source for neovim builtin LSP client
  'hrsh7th/cmp-path', -- nvim-cmp source for patha,
  'hrsh7th/nvim-cmp', -- nvim-cmp source for patha,
  'inside/vim-search-pulse', -- Easily locate the cursor after a search
  'luochen1990/rainbow', -- Rainbow parentheses,
  'nvim-lualine/lualine.nvim', -- Neovim statusline
  'preservim/vim-lexical', -- Build on Vim’s spell/thes/dict completion
  'roman/golden-ratio', -- Automatic resizing of windows to the golden ratio
  'tkatsu/vim-erblint', -- Shopify/erb-lint
  'tpope/vim-fugitive', -- Git wrapper
  'tpope/vim-rails', -- Ruby on Rails power tools
  'tpope/vim-rhubarb', -- GitHub extension for fugitive.vim
  'tpope/vim-surround', -- Delete/change/add parentheses/quotes/XML-tags/much more
  'vim-ruby/vim-ruby', -- Vim/Ruby Configuration Files
  'wsdjeg/vim-fetch', -- Handle line and column numbers in file names

  {
    -- Check syntax asynchronously and fix files
    "dense-analysis/ale",
    config = function()
      vim.g.ale_fix_on_save = 1
      vim.g.ale_fixers = { javascript = { "eslint" }, ruby = { "rubocop" } }
      vim.g.ale_ruby_rubocop_auto_correct_all = 1
      vim.g.ale_ruby_rubocop_executable = "bundle"

      vim.api.nvim_set_keymap('n', '<leader>af', ':ALEFix<CR>', { desc = "Ale fix" })

      vim.api.nvim_set_keymap(
        "n",
        "<leader>rd",
        [[:execute '!bundle exec rubocop --autocorrect-all --disable-uncorrectable ' . expand('%') | :%s/rubocop:todo/rubocop:disable/g<CR>]],
        { desc = "Rubocop disable uncorrectable" }
      )
    end
  },

  {
    'lewis6991/gitsigns.nvim', opts = {}, -- Shows git diff markers in the sign column
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
      -- Add other test providers here as needed
    },
    config = function()
      -- Set up keymaps for running tests
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")
        },
      })

      vim.keymap.set("n", "<Leader>t", ':Neotest run<CR>', { desc = "Test nearest" })
      -- TODO: this doesn't work with feature tagged specs (it runs as nearest)?
      vim.keymap.set("n", "<Leader>T", ':Neotest run file<CR>', { desc = "Test file" })
      vim.keymap.set("n", "<Leader>l", ':Neotest run last<CR>', { desc = "Test last" })

      vim.keymap.set("n", "<Leader>a", ':Neotest attach<CR>', { desc = "Test attach" })
      vim.keymap.set("n", "<Leader>o", ':Neotest output<CR>', { desc = "Test output" })
    end,
  },

  {
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'RRethy/base16-nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'base16-eighties'
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'ruby', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'javascript', 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Search Files' })
      vim.keymap.set('n', '<leader>/',  builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua'
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      -- if vim.g.have_nerd_font then
      --   local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      --   local diagnostic_signs = {}
      --   for type, icon in pairs(signs) do
      --     diagnostic_signs[vim.diagnostic.severity[type]] = icon
      --   end
      --   vim.diagnostic.config { signs = { text = diagnostic_signs } }
      -- end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        eslint = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' }
              },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
        -- rubocop = {}, TODO: get this working?
        solargraph = {}
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
