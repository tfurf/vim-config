syntax on
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize
set hidden

set nocp
if has("autocmd")
  filetype plugin indent on
endif

set wildmenu
set wildmode=list:longest

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"Color
set t_Co=256
set background=dark
colorscheme solarized

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$\|\t/
endif

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0

"vim-clang-format
let g:clang_format#command = 'clang-format-3.6'
let g:clang_format#detect_style_file = 1

"gitgutter
highlight clear SignColumn

"search selected text and replace
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

set sw=2
set ts=2
set title
set nu
set nowrap
set foldmethod=syntax
set incsearch
set ignorecase
set smartcase
set scrolloff=4
set smarttab
set expandtab

augroup vimrc_filetype
  autocmd!
  autocmd FileType python   call s:MyPythonSettings()    " C is same as Cpp
  autocmd FileType c        call s:MyCppSettings()    " C is same as Cpp
  autocmd FileType cpp      call s:MyCppSettings()
  autocmd FileType tex      call s:MyTeXSettings()
  autocmd FileType plaintex call s:MyTeXSettings()
  autocmd FileType xml      call s:MyXmlSettings()
  autocmd FileType kml      call s:MyXmlSettings()
  autocmd FileType xslt     call s:MyXmlSettings()
  autocmd FileType mail     call s:MyTextSettings()
  autocmd FileType markdown call s:MyMarkdownSettings()
  autocmd BufRead,BufNewFile *.launch set filetype=xml
  autocmd BufRead,BufNewFile *.md set filetype=markdown
augroup end

function! s:MyPythonSettings()
  set sw=2
endfunction

function! s:MyXmlSettings()
  set syntax=xml
  let g:xml_syntax_folding=1
endfunction

function! s:MyMarkdownSettings()
  set syntax=markdown
endfunction

function! s:MyCppSettings()
  "FSwitch
  au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs= './'
  au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs= './'
  imap <C-@> <C-Space>
  nmap <silent> <Leader>of :FSHere<cr>
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  " -- Taglist --
  nnoremap <silent> <F8> :TlistToggle<CR>
  let Tlist_Auto_Open = 1    " Start with taglist open.
  let TlistAddFileAlways = 1 " Add new files to the taglist.
  let Tlist_Enable_Fold_Column = 0 " Remove the fold columns.
  let Tlist_File_Fold_Auto_Close = 1 " Automatically remove stale files from taglist.
  let Tlist_Highlight_Tag_On_BufEnter = 1 " On entering buffer, highlight the current tag..
  " --- OmniCppComplete ---
  " -- optional --
  " auto close options when exiting insert mode
  set completeopt=menu,menuone,longest,preview
  " -- configs --
  let OmniCpp_NamespaceSearch = 2     " search namespaces in this and included files
  let OmniCpp_GlobalScopeSearch = 2   " search namespaces in this and included files
  let OmniCpp_MayCompleteDot = 1      " autocomplete with .
  let OmniCpp_MayCompleteArrow = 1    " autocomplete with ->
  let OmniCpp_MayCompleteScope = 1    " autocomplete with ::
  let OmniCpp_SelectFirstItem = 2     " select first item (but don't insert)
  let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e.  parameters) in popup window
  let OmniCpp_ShowScopeInAbbr = 1 "
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
  "let g:LatexBox_latexmk_async=0
  let g:LatexBox_latexmk_preview_continuously=1
  " Reformat paragraph.
  map <S-F12> gqip
  " For inline verbose:
  let g:surround_61 = "\\verb=\r="
  let g:surround_45 = "\$\r=i\$"
endfunction
