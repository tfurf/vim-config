syntax on
set sessionoptions=blank,buffers,globals,help,localoptions,options,resize
set hidden
set sw=2
set ts=2
set nu
set smartcase
set smarttab
set expandtab
set nowrap
set ignorecase
set nocp
" set foldmethod=syntax

set wildmode=list:longest

"Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" vim-plug
call plug#begin()
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'Valloric/YouCompleteMe', { 'do' : './install.py --clang-completer' , 'for' : ['cpp' , 'python' , 'bash' ] }
Plug 'airblade/vim-gitgutter'
  highlight clear SignColumn

"Plug 'altercation/vim-colors-solarized'
"Plug 'chriskempson/vim-tomorrow-theme'
"Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'derekwyatt/vim-fswitch'
Plug 'derekwyatt/vim-protodef'
Plug 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger="<s-tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"
Plug 'honza/vim-snippets'
Plug 'kana/vim-operator-user'
Plug 'plasticboy/vim-markdown', { 'for' : 'markdown' }
Plug 'rdnetto/YCM-Generator', { 'branch' : 'stable' }
Plug 'rhysd/vim-clang-format'
  let g:clang_format#command = 'clang-format-3.6'
  let g:clang_format#detect_style_file = 1

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
  " airline
  set laststatus=2
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#whitespace#enabled = 0

Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'papercolor'
Plug 'vim-voom/VOoM', { 'for': [ 'tex' , 'plaintex' , 'txt' ] }
Plug 'wincent/command-t', { 'do' : 'cd ruby/command-t && ruby extconf.rb && make' }
let g:CommandTFileScanner = "git"
call plug#end()

nnoremap <silent> <Leader>c <Plug>(CommandTHistory)
nnoremap <silent> <Leader>r <Plug>(CommandTTag)

"Color
"set t_Co=256
set background=dark
"colorscheme Tomorrow-Night
colorscheme PaperColor
"colorscheme solarized
let base16colorspace=256
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

function! s:MyXmlSettings()
  set syntax=xml
  let g:xml_syntax_folding=1
endfunction

function! s:MyMarkdownSettings()
  set syntax=markdown
  set wrap
endfunction

function! s:MyCppSettings()
  "FSwitch
  au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs= './'
  au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs= './'
  imap <C-@> <C-Space>
  nmap <silent> <Leader>of :FSHere<cr>
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

  nmap <silent> <Leader>m :Make -j7 -l8<cr>
  " -- Taglist --
  " nnoremap <silent> <F8> :TlistToggle<CR>
  " let Tlist_Auto_Open = 1    " Start with taglist open.
  " let TlistAddFileAlways = 1 " Add new files to the taglist.
  " let Tlist_Enable_Fold_Column = 0 " Remove the fold columns.
  " let Tlist_File_Fold_Auto_Close = 1 " Automatically remove stale files from taglist.
  " let Tlist_Highlight_Tag_On_BufEnter = 1 " On entering buffer, highlight the current tag..
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
