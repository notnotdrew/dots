-- Set runtime path for fzf
vim.opt.rtp:append("/usr/local/opt/fzf")

-- Temporary fix for https://github.com/vim/vim/issues/3117
if vim.fn.has("python3") == 1 then
  pcall(vim.api.nvim_exec, "python3 1", false)
end

-- Colorscheme
vim.cmd("colorscheme gruvbox")
vim.opt.background = "dark"

-- Show line numbers
vim.opt.number = true

-- Reload init.lua with <leader>s
vim.keymap.set("n", "<leader>s", ":luafile ~/.config/nvim/init.lua<CR>", { silent = true })

vim.opt.hidden = true
vim.opt.history = 100
vim.opt.laststatus = 2
vim.opt.termguicolors = true

-- Indentation
vim.cmd("filetype indent on")
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Strip trailing whitespace on write (uncomment if needed)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   command = ":%s/\\s\\+$//e"
-- })

-- Custom commands
vim.cmd([[
command W w
command Q q
command Vsp vsp
]])

-- Test settings
vim.g["test#ruby#rspec#executable"] = "bundle exec rspec"
vim.g["test#javascript#jest#executable"] = "yarn nx test"

-- Search
vim.opt.hlsearch = true
vim.keymap.set("v", "//", 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>', { silent = true })

-- gf suffixes
vim.opt.suffixesadd:append({ ".js", ".coffee", ".jsx", ".json" })

-- Grep word under cursor with K
vim.keymap.set("n", "K", ':grep! "\\b<C-R><C-W>\\b"<CR>:cw<CR>', { silent = true })

-- Run tests with leader
vim.keymap.set("n", "<Leader>t", ":w<CR>:TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<Leader>T", ":w<CR>:TestFile<CR>", { silent = true })
vim.keymap.set("n", "<Leader>l", ":w<CR>:TestLast<CR>", { silent = true })
vim.keymap.set("n", "<Leader>F", ":w<CR>:TestFile --tag feature<CR>", { silent = true })
vim.keymap.set("n", "<Leader>f", ":w<CR>:TestNearest --tag feature<CR>", { silent = true })
vim.keymap.set("n", "<Leader>v", ":w<CR>:TestLast --tag feature<CR>", { silent = true })

-- Delete file
vim.keymap.set("n", "<leader>D", ":call delete(expand('%')) | bdelete!<CR>", { silent = true })
vim.keymap.set("n", "<leader>rm", ":call delete(expand('%')) | bdelete!<CR>", { silent = true })

-- FZF bindings
vim.keymap.set("n", "<C-P>", ":FZF<CR>", { silent = true })
vim.keymap.set("n", "<C-B>", ":Buffers<CR>", { silent = true })
vim.keymap.set("n", "<Leader>c", ":Btags<CR>", { silent = true })
vim.keymap.set("n", "<Leader>C", ":Tags<CR>", { silent = true })

-- Show matching parentheses
vim.opt.showmatch = true

-- Syntax highlighting
vim.cmd("syntax enable")

-- Lightline configuration
vim.g.lightline = {
  colorscheme = "gruvbox",
  active = {
    left = { { "mode", "paste" }, { "fugitive", "filename" } }
  },
  component_function = {
    fugitive = "LightlineFugitive",
    readonly = "LightlineReadonly",
    modified = "LightlineModified",
    filename = "LightlineFilename"
  },
  separator = { left = "", right = "" },
  subseparator = { left = "|", right = "|" }
}

vim.cmd([[
function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "RO"
  else
    return ""
  endif
endfunction

function! LightlineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction
]])

-- The Silver Searcher (ag) settings
vim.cmd([[
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
]])

if vim.fn.executable("ag") == 1 then
  vim.opt.grepprg = "ag --nogroup --nocolor"
  vim.g.ctrlp_user_command = "ag %s -l --nocolor -g ''"
  vim.g.ctrlp_use_caching = 0
end

-- ALE linting
vim.g.ale_sign_column_always = 1
vim.g.ale_linters = {
  ruby = { "rubocop", "reek" },
  javascript = { "eslint" },
  jsx = { "eslint" },
  erb = { "bundle exec erblint --lint-all" },
  html = { "tidy" }
}

-- File navigation
vim.keymap.set("n", "<Leader>e", ":e <C-R>=expand('%:p:h') . '/'<CR>", { silent = true })
vim.keymap.set("n", "<Leader>r", ":r <C-R>=expand('%:p:h') . '/'<CR>", { silent = true })