syntax on
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize
set hidden
set nocp
if has("autocmd")
    filetype plugin indent on
endif

" Airline needs work.
let g:loaded_airline=1

" Why is powerline fubaring on vimdiff?
" let g:powerline_loaded=1

" For solarized theme. This was a pain to figure out the best setting.
" set t_Co=16
" set background=dark
" call togglebg#map("<F5>")
" colorscheme solarized

" Pathogen
execute pathogen#infect()

"explorer mappings
nnoremap <f1> :BufExplorer<cr>
nnoremap <f2> :NERDTreeToggle<cr>
nnoremap <f3> :TagbarToggle<cr>

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

augroup vimrc_filetype
    autocmd!
    autocmd FileType c  call s:MyCppSettings()    " C is same as Cpp
    autocmd FileType cpp call s:MyCppSettings()
    autocmd FileType tex call s:MyTeXSettings()
    autocmd FileType plaintex call s:MyTeXSettings()
    autocmd Filetype bib call s:MyBiBSettings() " TeX and BiB are the same.
    autocmd FileType sh call s:MyBashSettings()
    autocmd FileType python call s:MyPythonSettings()
    autocmd FileType make call s:MyMakeSettings()
    autocmd FileType vim call s:MyVimSettings()
    autocmd FileType matlab call s:MyMatlabSettings()
    autocmd FileType tcl call s:MyTclSettings()
    autocmd FileType xml call s:MyXmlSettings()
    autocmd FileType yaml call s:MyXmlSettings()
    autocmd FileType kml call s:MyXmlSettings()
    autocmd FileType javascript call s:MyTclSettings()
    autocmd BufRead,BufNewFile *.launch set filetype=xml
augroup end

function! s:MyXmlSettings()
    let g:xml_syntax_folding=1
    au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/plugin/XMLFolding.vim
    set expandtab
endfunction

function! s:MyTclSettings()
    set smartindent
    set expandtab
endfunction

function! s:MyCppSettings()
    set expandtab
    "FSwitch
    au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs= './'
    au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs= './'
    " For ctags and taglist:
    nnoremap <silent> <S-F9> :TlistToggle<CR> 
    map <C-F12> :!ctags -R --c++-kinds=+lp --fields=+iaS --extra=+q .<CR>
    set tags+=~/.vim/tags/cpp
    let g:Tlist_WinWidth = 40            "Sets width of taglist pane, default is 30.A
    let g:Tlist_Display_Prototype = 1    "Display tag prototypes and tag names in window.
    let g:Tlist_Compact_Format = 1       " Compact format..
    let g:Tlist_File_Fold_Auto_Close = 1 " Automatically fold unfocused (files)in tree
    let g:Tlist_Process_File_Always = 1
    let g:Tlist_GainFocus_On_ToggleOpen = 1
    set ofu=omni#cpp#complete#Main
"    inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
"        \ "\<lt>C-n>" :
"        \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
"        \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
"        \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
    imap <C-@> <C-Space>
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    " --- OmniCppComplete ---
    " -- optional --
    " auto close options when exiting insert mode
    set completeopt=menu,menuone,longest,preview
    " -- configs --
    let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
    let OmniCpp_GlobalScopeSearch = 2 " search namespaces in this and included files
    let OmniCpp_MayCompleteDot = 1 " autocomplete with .
    let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
    let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
    let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
    let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e.  parameters) in popup window
    let OmniCpp_ShowScopeInAbbr = 1 " 

endfunction

function! s:MyMatlabSettings()
    set expandtab
    source $VIMRUNTIME/macros/matchit.vim
    autocmd BufEnter *.m compiler mlint
endfunction

function! s:MyVimSettings()
    set expandtab
endfunction

function! s:MyBashSettings()
    set expandtab
endfunction "End s:MyBashSettings()

function! s:MyMakeSettings()
    set titlestring=%f
endfunction "s:MyMakeSettings()

function! s:MyTeXSettings()
    set wrap
    set tw=0
    set wm=0
    set expandtab
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
    " let g:LatexBox_latexmk_options = '-pvc'
    let g:LatexBox_latexmk_async=1
    let g:LatexBox_latexmk_preview_continuously=1
    " Reformat paragraph.
    map <S-F12> gqip       
    " For inline verbose:
    let g:surround_61 = "\\verb=\r="
    let g:surround_45 = "\$\r=i\$"
endfunction "s:MyTeXSettings()

function! s:MyBiBSettings()
    set tw=79
    set expandtab
endfunction "s:MyBiBSettings()

function! s:MyPythonSettings()
    set expandtab
endfunction "s:MyBiBSettings()
