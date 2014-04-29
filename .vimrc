syntax on
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,resize
set hidden
set nocp
if has("autocmd")
    filetype plugin indent on
endif

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

"explorer mappings
nnoremap <f1> :NERDTreeToggle<cr>

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
    autocmd FileType c  call s:MyCppSettings()    " C is same as Cpp
    autocmd FileType cpp call s:MyCppSettings()
    autocmd FileType tex call s:MyTeXSettings()
    autocmd FileType plaintex call s:MyTeXSettings()
    autocmd FileType xml call s:MyXmlSettings()
    autocmd FileType yaml call s:MyXmlSettings()
    autocmd FileType kml call s:MyXmlSettings()
    autocmd FileType xslt call s:MyXmlSettings()
    autocmd BufRead,BufNewFile *.launch set filetype=xml
augroup end

function! s:MyXmlSettings()
    let g:xml_syntax_folding=1
    au BufNewFile,BufRead *.xml,*.htm,*.html,*.xslt so ~/.vim/plugin/XMLFolding.vim
endfunction

function! s:MyCppSettings()
    "FSwitch
    au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs= './'
    au! BufEnter *.h let b:fswitchdst = 'cpp,c' | let b:fswitchlocs= './'
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
    " let g:LatexBox_latexmk_options = '-pvc'
    let g:LatexBox_latexmk_async=1
    let g:LatexBox_latexmk_preview_continuously=1
    " Reformat paragraph.
    map <S-F12> gqip       
    " For inline verbose:
    let g:surround_61 = "\\verb=\r="
    let g:surround_45 = "\$\r=i\$"
endfunction 
