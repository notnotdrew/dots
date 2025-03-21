" Plugins
" --------------

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin()

Plug 'DataWraith/auto_mkdir' " Save files into directories that do not exist yet
Plug 'RRethy/vim-illuminate' " Highlight other uses of the word under the cursor
Plug 'airblade/vim-gitgutter' " Git diff markers in the sign column
Plug 'andrewradev/splitjoin.vim' " Switch between single-line and multiline forms of code
Plug 'bronson/vim-trailing-whitespace' " Highlights trailing whitespace in red
Plug 'dense-analysis/ale' " Async linter
Plug 'ervandew/supertab' " Insert mode completions with Tab
Plug 'inside/vim-search-pulse' " Easily locate the cursor after a search
Plug 'junegunn/fzf' " Necessary for fzf.vim
Plug 'junegunn/fzf.vim' " fzf + vim
Plug 'luochen1990/rainbow' " Rainbow parentheses
Plug 'preservim/vim-lexical' " Build on Vim’s spell/thes/dict completion
Plug 'roman/golden-ratio' " Automatic resizing of windows to the golden ratio
Plug 'sainnhe/everforest' " Comfortable & Pleasant Color Scheme for Vim
Plug 'sainnhe/gruvbox-material' " Gruvbox with Material Palette
Plug 'sheerun/vim-polyglot' " Language pack for Vim
Plug 'tkatsu/vim-erblint' " Shopify/erb-lint
Plug 'tlhr/anderson.vim' " Based on colors from Wes Anderson films
Plug 'tpope/vim-dispatch' " Asynchronous build and test dispatcher
Plug 'tpope/vim-rails' " Ruby on Rails power tools
Plug 'tpope/vim-surround' " Delete/change/add parentheses/quotes/XML-tags/much more
Plug 'vim-ruby/vim-ruby' " Vim/Ruby Configuration Files
Plug 'vim-test/vim-test' " It's tests
Plug 'wsdjeg/vim-fetch' " Handle line and column numbers in file names

call plug#end() " Automatically executes filetype plugin indent on and syntax enable

" Options
" --------------
set background=dark " Set dark background (works with many colorschemes)
set colorcolumn=79 " Show vertical column
set completeopt=menuone,noselect " [TRIAL] Set completeopt to have a better completion experience
set cursorline " Highlight current line
set expandtab " Convert tabs to spaces
set hidden " Keep unsaved buffers open when switching files
set history=100 " Keep command history (e.g., last 100 commands)
set hlsearch " Enable highlight search
set ignorecase " Ignore case when searching
set incsearch " Highlight matches as you type (without persisting)
set laststatus=2 " Always show the status line (2 = always visible)
set list " Show invisible chars
set listchars=tab:»·,trail:· " Show tabs and trailing whitespace only
set number " Show line numbers
set scrolloff=7 " Always show 3 lines around cursor
set shiftwidth=2 " Indent by 2 spaces when using ">" or auto-indent
set showmatch " Show matching parentheses
set smartcase " Turn case sensitive search back on in certain cases
set smartindent " Enable smarter auto-indentation
set suffixesadd+=.coffee,.js,.json,.jsx,.rb " Append these extensions for `gf` (go to file)
set tabstop=2 " Set tab width to 2 spaces
set termguicolors " Enables 24-bit RGB color
set nowrap " Disable line wrapping
set signcolumn=yes " Always show signcolumn

" Variables
" ----------------
let &t_SI = "\e[5 q" " Blinking line in insert mode
let &t_EI = "\e[2 q" " Block cursor in normal mode
let g:have_nerd_font = 1 " Use an installed Nerd Font from terminal
let g:ale_linters_explicit = 1
let g:ale_linters= {'ruby': ['rubocop', 'standardrb']}
let g:ale_fixers = {'ruby': ['rubocop', 'standardrb']}
let g:ale_ruby_rubocop_executable = "bin/rubocop"
let g:ale_ruby_standardrb_executable = "bin/standardrb"
let g:ale_fix_on_save = 1
let g:gitgutter_set_sign_backgrounds = 1 " Don't highlight gitgutter
let g:ruby_indent_assignment_style = 'variable' " Resolves a conflict with standardrb
let g:ruby_indent_hanging_elements = 0 " Resolves a conflict with standardrb
let g:test#javascript#jest#options = '--reporters jest-vim-reporter' " https://www.npmjs.com/package/jest-vim-reporter
let g:test#strategy = 'vimterminal' " Runs test commands with term_start() in a split window.

" Commands
" ----------------
command W w
command Q q
command Vsp vsp
command! ALEDisableRubyRule call ALEDisableRubyRule()

" Keymaps
" --------------

" Bind "K" to search for the word under the cursor using "grep" and show results in the quickfix window
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Delete file
nnoremap <leader>D :call delete(expand('%')) \| bdelete!<CR>

" Edit file
nnoremap <Leader>e :e <C-R>=expand("%:p:h") . "/"<CR>

" Read file
nnoremap <Leader>r :r <C-R>=expand("%:p:h") . "/"<CR>

" Run tests
nnoremap <Leader>t :w<CR>:TestNearest<CR>
nnoremap <Leader>T :w<CR>:TestFile<CR>
nnoremap <Leader>l :w<CR>:TestLast<CR>

" Run feature tests
nnoremap <Leader>f :w<CR>:TestNearest --tag feature<CR>
nnoremap <Leader>F :w<CR>:TestFile --tag feature<CR>
nnoremap <Leader>v :w<CR>:TestLast --tag feature<CR>

" Fuzzy find
nnoremap <C-P> <CR>:Files<CR>
nnoremap <C-B> <CR>:Buffers<CR>

" Linter
nnoremap <leader>ld :ALEDisableRubyRule<CR>
nnoremap <leader>lf :ALEFix<CR>

" Functions
" --------------

" NOTE: for some reason, the environment's BAT_THEME is not picked up, and
" outside of a function call, neither is let $BAT_THEME. In this function
" though, it is :shrug:
function! GruvboxTheme()
  let $BAT_THEME='base16' " Set BAT_THEME for fzf previews
  colorscheme gruvbox-material
endfunction

function! ALEDisableRubyRule()
  let l:line = line('.')
  let l:loclist = getloclist(0)
  let l:rules = []

  for l:item in l:loclist
    if l:item.lnum == l:line && has_key(l:item, 'text') && !empty(l:item.text)
      let l:rule = matchstr(l:item.text, '\v(\w+/[^:]+)')
      if !empty(l:rule)
        call add(l:rules, l:rule)
      endif
    endif
  endfor

  if empty(l:rules)
    echo "No rules found for this line."
    return
  endif

  let l:rules = uniq(sort(l:rules))

  if l:rules[0] =~# '^standard/'
    let l:comment = '# standard:disable ' . join(l:rules, ', ')
  else
    let l:comment = '# rubocop:disable ' . join(l:rules, ', ')
  endif

  call setline('.', getline('.') . ' ' . l:comment)
  echo "Added: " . l:comment
endfunction

call GruvboxTheme()
