set rtp+=/usr/local/opt/fzf

" added temporarily because https://github.com/vim/vim/issues/3117
if has('python3')
  silent! python3 1
endif

colorscheme gruvbox
" colorscheme kanagawa
set background=dark

" show line numbers
set number

" reload .vimrc with \s
map <leader>s :source ~/.vimrc<CR>

set hidden
set history=100
set laststatus=2
set t_Co=256

" indentation
filetype indent on
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent

" strip whitespace on write
" autocmd BufWritePre * :%s/\s\+$//e

" stop being annoying
command W w
command Q q
command Vsp vsp
" needs to take the range into account :thinking:
" command Sort sort

" test
let test#ruby#rspec#executable = 'bundle exec rspec'
let test#javascript#jest#executable = "yarn nx test"

" search
set hlsearch
" the following is some worthless garbage that only causes trouble
" nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" search visually selected text, literally with //
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

" gf suffixes
set suffixesadd=.js,.coffee,.jsx,.json

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" run tests with leader
nnoremap <Leader>t :w<CR>:TestNearest<CR>
nnoremap <Leader>T :w<CR>:TestFile<CR>
nnoremap <Leader>l :w<CR>:TestLast<CR>

nnoremap <Leader>F :w<CR>:TestFile --tag feature<CR>
nnoremap <Leader>f :w<CR>:TestNearest --tag feature<CR>
nnoremap <Leader>v :w<CR>:TestLast --tag feature<CR>

nnoremap <leader>D :call delete(expand('%')) \| bdelete!<CR>

" fzf for fuzzy find
nnoremap <C-P> <CR>:FZF<CR>
nnoremap <C-B> <CR>:Buffers<CR>
nnoremap <Leader>c <CR>:Btags<CR>
nnoremap <Leader>C <CR>:Tags<CR>


" delete file
nnoremap <Leader>rm :call delete(expand('%')) \| bdelete!<CR>

" matching parenthesis & stuff
set showmatch

syntax enable

execute pathogen#infect()

" make ctrlp fuzzy search not suck
" let g:ctrlp_regexp=1

" rainbow
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }

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
" end lightline

" The Silver Searcher
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Ale (linting)
let g:ale_sign_column_always = 1
let g:ale_linters = {
                    \  'ruby': ['rubocop', 'reek'],
                    \  'javascript': ['eslint'],
                    \  'jsx': ['eslint'],
                    \  'erb': ['bundle exec erblint --lint-all'],
                    \  'html': ['tidy']
                    \}

" " syntastic
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_mode_map = {
"       \ 'mode': 'passive',
"       \ 'active_filetypes': ['ruby', 'elixir', 'javascript'],
"       \ 'passive_filetypes': []
"       \ }

if executable('matcher')
	let g:ctrlp_match_func = { 'match': 'GoodMatch' }

	function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

	  " Create a cache file if not yet exists
	  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
	  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
		call writefile(a:items, cachefile)
	  endif
	  if !filereadable(cachefile)
		return []
	  endif

	  " a:mmode is currently ignored. In the future, we should probably do
	  " something about that. the matcher behaves like "full-line".
	  let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
	  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
		let cmd = cmd.'--no-dotfiles '
	  endif
	  let cmd = cmd.a:str

	  return split(system(cmd), "\n")

	endfunction
end

" Steven's config. Delete later
" map <C-J> <C-W>j<C-W>_
" map <C-K> <C-W>k<C-W>_
" map <C-H> <C-W>h<C-W>_
" map <C-L> <C-W>l<C-W>_
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>
nnoremap <Leader>r :r <C-R>=expand('%:p:h') . '/'<CR>
" inoremap jk <ESC>
" inoremap jj <ESC>
" inoremap kj <ESC>
" inoremap kj <ESC>
" inoremap kk <ESC>
