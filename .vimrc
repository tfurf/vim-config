syntax on

set sessionoptions=blank,buffers,globals,help,localoptions,options,resize
set hidden
set sw=4
set ts=4
set nu
set smartcase
set smarttab
set expandtab
set nowrap
set ignorecase
set nocp
" set foldmethod=syntax

set wildmode=list:longest

if has('nvim')
  set guicursor=
endif
let g:python3_host_prog = '/usr/bin/python3.8'
"Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" vim-plug
call plug#begin()
"  let g:plug_url_format = 'http://gitlab.scinet.cmre.nato.int/external/github.com/%s.git'
"Plug 'Valloric/YouCompleteMe', { 'do' : './install.py --clang-completer' , 'for' : ['cpp' , 'python' , 'bash' ] }
" let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
" let g:ycm_always_populate_location_list = 1
" nnoremap <Leader>yg :YcmCompleter GoTo<CR>
" nnoremap <Leader>yf :YcmCompleter FixIt<CR>
" nnoremap <Leader>yd :YcmShowDetailedDiagnostic<CR>
" nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
" autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
"
Plug 'neoclide/coc.nvim', {'branch': 'release'}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

nmap <leader>qf  <Plug>(coc-fix-current)
nmap <leader>cl  <Plug>(coc-codelens-action)


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

Plug 'ryanoasis/vim-devicons'

Plug 'airblade/vim-gitgutter'
  highlight clear SignColumn

Plug 'psf/black', { 'branch' : 'stable' , 'for': ['python'] }
  nnoremap <F6> :Black<CR>
Plug 'nvie/vim-flake8'
"Plug 'altercation/vim-colors-solarized'
"Plug 'chriskempson/vim-tomorrow-theme'
"Plug 'chriskempson/base16-vim'
"Plug 'NLKNguyen/papercolor-theme'
Plug 'sbdchd/neoformat'
"Plug 'beloglazov/vim-online-thesaurus'
"Plug 'derekwyatt/vim-fswitch'
"Plug 'derekwyatt/vim-protodef'
"Plug 'SirVer/ultisnips'
"  let g:UltiSnipsExpandTrigger="<s-tab>"
"  let g:UltiSnipsJumpForwardTrigger="<c-b>"
"  let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"Plug 'honza/vim-snippets'
Plug 'kana/vim-operator-user'
Plug 'junegunn/vim-easy-align'
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)

Plug 'sainnhe/gruvbox-material'

" Plug 'nvim-treesitter/nvim-treesitter'


Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }
Plug 'rdnetto/YCM-Generator', { 'branch' : 'stable' }
Plug 'rhysd/vim-clang-format'
"  let g:clang_format#command = 'clang-format-4.6'
  let g:clang_format#detect_style_file = 1

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif
Plug 'tpope/tpope-vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

Plug 'vim-airline/vim-airline'
  " airline
  set laststatus=2
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#whitespace#enabled = 0

Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'gruvbox_material'

Plug '$HOME/.fzf' | Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = [ 'down:40%' ]

nmap <Leader>t :Files<cr>
nmap <Leader>g :GFiles<cr>
nmap <Leader>b :Buffers<cr>
nmap <Leader>a :Ag<cr>
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file)
imap <c-x><c-l> <plug>(fzf-complete-line)

if has('nvim')
Plug 'chrisbra/vim-diff-enhanced'
  if &diff
    let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
  endif
endif

call plug#end()

"Color
"set t_Co=256
set background=dark
colorscheme gruvbox-material
"let base16colorspace=256
"colorscheme base16-default-dark

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$\|\t/
endif

augroup vimrc_filetype
  autocmd!
  autocmd FileType {c,cpp}        call s:MyCppSettings()    " C is same as Cpp
  autocmd FileType *tex           call s:MyTeXSettings()
  autocmd FileType {xml,kml,xslt} call s:MyXmlSettings()
  autocmd FileType mail           call s:MyTextSettings()
  autocmd FileType markdown       call s:MyMarkdownSettings()
  autocmd FileType python         call s:MyPythonSettings()
  autocmd BufRead,BufNewFile *.launch set filetype=xml
  autocmd BufRead,BufNewFile *.md set filetype=markdown
augroup end

function! RemoveTrailingWhiteSpace()
  let l:save_cursor = getpos('.')
  let l:winview = winsaveview()
  %s/\s\+$//e
  call setpos('.', l:save_cursor)
  call winrestview(l:winview)
endfunction

noremap <Leader>w :call RemoveTrailingWhiteSpace()<CR>

function! s:MyPythonSettings()
  set syntax=python
  set sw=2
  set ts=2
endfunction

function! s:MyXmlSettings()
  set syntax=xml
  let g:xml_syntax_folding=1
endfunction

function! s:MyMarkdownSettings()
  set syntax=markdown
  set wrap
endfunction

function! s:MyPythonSettings()
endfunction

function! s:MyCppSettings()
  "FSwitch
  au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs= './'
  au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs= './'
  imap <C-@> <C-Space>
  nmap <silent> <Leader>of :FSHere<cr>
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

  nmap <silent> <Leader>m :Make -j7 -l8<cr>
endfunction

function! s:MyTextSettings()
  set wrap
  set tw=0
  set wm=0
  set spell
  setlocal spell spelllang=en_gb
endfunction

function! s:MyTeXSettings()
  set wrap
  set tw=0
  set wm=0
  set spell
  setlocal spell spelllang=en_gb
  " For latex-box
  map <S-F9> <C-X><C-O>
  map <buffer> [[ \begin{
  imap <buffer> ]] <Plug>LatexCloseCurEnv
  nmap <buffer> <F5> <Plug>LatexChangeEnv
  vmap <buffer> <F7> <Plug>LatexWrapSelection
  vmap <buffer> <S-F7> <Plug>LatexEnvWrapSelection
  imap <buffer> (( \eqref{
  " Reformat paragraph.
  map <S-F12> gqip
  " For inline verbose:
  let g:surround_61 = "\\verb=\r="
  let g:surround_45 = "\$\r=i\$"
endfunction
