" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set nu
syntax enable
syntax on

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

"  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"----------------------NERDTree插件
"只有nerdtree时关闭vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"在没有指定文件的情况下打开vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"NERDTree快捷键
map <F9> <Esc>:NERDTreeToggle<CR> 

"配色 
colorscheme desert

"---------------------TagList插件
nnoremap <silent> <F8> :TlistToggle<CR>
let Tlist_Auto_Open=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Highlight_Tag_On_BufEnter=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1
let Tlist_Show_One_File=1
"let Tlist_Use_Horiz_Window = 1
let Tlist_Use_Right_Window = 1

"--------------------cscope
set cscopequickfix=s-,c-,d-,i-,t-,e-

"--------------------MiniBufExplorer
"C-w,h j k l    向"左,下,上,右"切换窗口
"let g:miniBufExplMapWindowNavVim = 1

"-------------------grep 插件
nnoremap <silent> <F3> :Grep<CR>  

"-------------------new-omni-completion 内置命令
filetype plugin indent on
set completeopt=longest,menu

"-------------------supertab 插件
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

"------------------ nerdcomment 插件 自定义快捷键
"map <C-/> \cc<CR>
"map <C-\> \cu<CR>
"B
"A
"map <C-[> \cs<CR> 
"A
""A
"A
""map <C-]> \cu<CR> 

"-------------------WinManager 插件
let g:winManagerWindowLayout="NERDTree|TagList"
let g:NERDTree_title="[NERDTree]"

nmap <C-m> :WMToggle<CR>

function! NERDTree_Start()  
	exec 'NERDTree'  
endfunction

function! NERDTree_IsValid()  
	return 1  
endfunction

let g:winManagerWidth = 30
let g:defaultExplorer = 0
nmap <C-W><C-F> :FirstExplorerWindow<cr>
nmap <C-W><C-B> :BottomExplorerWindow<cr>
nmap <silent> <leader>wm :WMToggle<cr>
"function! ToggleNerdtreeTagbar()

	" check if NERDTree and Tagbar are opened
"	let NERDTree_close = (bufwinnr('NERD_tree') == -1) 
"	let Tagbar_close   = (bufwinnr('__Tagbar__') == -1) 

"	TagbarToggle
"	NERDTreeToggle

"	if NERDTree_close && Tagbar_close
"		wincmd K
"		wincmd b
"		wincmd L
"		wincmd h
"		exe 'vertical resize 30'
"	endif

"endfunction
"nmap <F6> :call ToggleNerdtreeTagbar()<CR>


"-------------------自定义快捷键，分割窗口resize
nmap h= :resize +5<CR>
nmap h- :resize -5<CR>
nmap v= :vertical resize +5<CR>
nmap v- :vertical resize -5<CR>

set nobackup
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
"set autoindent
set smartindent

set textwidth=78

"---------------------- php 设置
"let php_folding=1
let php_sql_query = 1
let php_baselib = 1
let php_htmlInStrings = 1
"let g:php_folding=2
"set foldmethod=syntax

"----------------- c 语言设置
"autocmd FileType c,cpp  setl fdm=syntax | setl fen


set fileformats=unix,dos



call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go'
call plug#end()

autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
