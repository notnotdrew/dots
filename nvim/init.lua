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
  {
    'DataWraith/auto_mkdir', -- Save files into directories that do not exist yet
  },

  {
    'RRethy/vim-illuminate', -- Highlight other uses of the word under the cursor
  },

  {
    'andrewradev/splitjoin.vim', -- Switch between single-line and multiline forms of code
  },

  {
    'bronson/vim-trailing-whitespace', -- Highlights trailing whitespace in red
  },

  {
    'hrsh7th/nvim-cmp', -- nvim-cmp source for patha,
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require'cmp'

      cmp.setup({
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end
  },

  {
    'inside/vim-search-pulse', -- Easily locate the cursor after a search
  },

  {
    'luochen1990/rainbow', -- Rainbow parentheses,
  },

  {
    'nvim-lualine/lualine.nvim', -- Neovim statusline
  },

  {
    'preservim/vim-lexical', -- Build on Vim’s spell/thes/dict completion
  },

  {
    'roman/golden-ratio', -- Automatic resizing of windows to the golden ratio
  },

  {
    'tkatsu/vim-erblint', -- Shopify/erb-lint
  },

  {
    'tpope/vim-fugitive', -- Git wrapper
  },

  {
    'tpope/vim-rails', -- Ruby on Rails power tools
  },

  {
    'tpope/vim-rhubarb', -- GitHub extension for fugitive.vim
  },

  {
    'tpope/vim-surround', -- Delete/change/add parentheses/quotes/XML-tags/much more
  },

  {
    'vim-ruby/vim-ruby', -- Vim/Ruby Configuration Files
  },

  {
    'wsdjeg/vim-fetch', -- Handle line and column numbers in file names
  },

  {
    'lewis6991/gitsigns.nvim', -- Shows git diff markers in the sign column
    opts = {},
  },

  {
    "nvim-neotest/neotest", -- Interact with tests within NeoVim
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    config = function()
      local neotest = require("neotest")

      neotest.setup({
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              return vim.tbl_flatten({ "bundle", "exec", "rspec", "--no-tty" })
            end
          })
        },
      })

      -- Keymaps for running tests
      vim.keymap.set("n", "<Leader>t", function() neotest.run.run() end, { desc = "Test nearest" })
      vim.keymap.set("n", "<Leader>T", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Test file" })
      vim.keymap.set("n", "<Leader>l", function() neotest.run.run_last() end, { desc = "Test last" })

      -- Attach, Output, and Status management
      vim.keymap.set("n", "<Leader>ta", function() neotest.run.attach() end, { desc = "Attach to test" })
      vim.keymap.set("n", "<Leader>to", function() neotest.output.open() end, { desc = "Show test output" })

      -- Optional: Add diagnostic UI (useful for quick debugging)
      vim.keymap.set("n", "<Leader>ts", function() neotest.summary.toggle() end, { desc = "Toggle test summary" })
    end,
  },

  {
    'RRethy/base16-nvim', -- base16 colorschemes
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'base16-eighties'
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter', -- Highlight, edit, and navigate code
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'diff', 'html', 'javascript', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'ruby', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  {
    'nvim-telescope/telescope.nvim', -- Fuzzy Finder (files, lsp, etc)
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
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
    end,
  },

  {
    'folke/todo-comments.nvim', -- Highlight todo, notes, etc in comments
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
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
