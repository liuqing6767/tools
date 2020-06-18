""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 获取Vundle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"
"" 常用的命令
" :PluginList       - 列出所有已配置的插件
" " :PluginInstall     - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" " :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" " :PluginClean      - 清除未使用插件,需要确认; 追加 `!`
" 自动批准移除未使用插件
" "
"查阅 :h vundle 获取更多细节和wiki以及FAQ


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 配置 Vundle
set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" 另一种选择, 指定一个vundle安装插件的路径
"call vundle#begin('~/some/path/here')

" 让vundle管理插件版本,必须
Plugin 'VundleVim/Vundle.vim'

" 以下范例用来支持不同格式的插件安装.
" 请将安装插件的命令放在vundle#begin和vundle#end之间.
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
" Plugin 'tpope/vim-fugitive'
" " 来自 http://vim-scripts.org/vim/scripts.html 的插件
" " Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
" Plugin 'L9'
" " 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
" Plugin 'git://git.wincent.com/command-t.git'
" " 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
" Plugin 'file:///home/gmarik/path/to/plugin'
" " 插件在仓库的子目录中.
" " 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" " 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
" Plugin 'ascenator/L9', {'name': 'newL9'}

" vim开发
Plugin 'fatih/vim-go'
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" 注解生成
" :Dox
Plugin 'vim-scripts/DoxygenToolkit.vim'
Plugin 'git://github.com/scrooloose/nerdtree.git'
"Plugin 'git://github.com/vim-scripts/minibufexplorerpp.git'
Plugin 'git://github.com/jiangmiao/auto-pairs.git'
Plugin 'git://github.com/majutsushi/tagbar.git'
Plugin 'git://github.com/EvanDotPro/vim-php-syntax-check.git'

Plugin 'godlygeek/tabular'
" markdown
Plugin 'plasticboy/vim-markdown'
" zc close
" zo open



Plugin 'Valloric/YouCompleteMe'
" cd ~/.vim/bundle/YouCompleteMe && ./install.py --gocode-completer --clang-completer

Plugin 'alvan/vim-closetag'
" http://www.zfanw.com/blog/zencoding-vim-tutorial-chinese.html
Plugin 'mattn/emmet-vim'
Plugin 'Yggdroot/indentLine'
Plugin 'othree/javascript-libraries-syntax.vim'
"Plugin 'vim-syntastic/syntastic'

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
" filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
filetype plugin on
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype on

"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplModSelTarget = 1 

" emmet-vim
let g:user_emmet_leader_key='<C-E>'

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" YCM
" let g:ycm_show_diagnostics_ui = 0
let g:ycm_auto_trigger = 1
let g:ycm_min_num_identifier_candidate_chars = 10
" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:syntastic_always_populate_loc_list = 1
" YouCompleteMe 功能
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf=1
" 开启 YCM 基于标签引擎
"let g:ycm_collect_identifiers_from_tags_files=1
" 引入 C++ 标准库tags，这个没有也没关系，只要.ycm_extra_conf.py文件中指定了正确的标准库路径
"set tags+=/data/misc/software/misc./vim/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现，只显示补全列表
set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1
" 修改对C函数的补全快捷键，默认是CTRL + space，修改为ALT + ;
" ctrl + p
let g:ycm_key_invoke_completion = '<M-;>'
" 设置转到定义处的快捷键为ALT + G，这个功能非常赞
nmap <M-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NerdCommenter
let mapleader = "/" "设<Leader>
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" <Leader>cn //注释当前[选中]行
" <Leader>cm /**/注释当前[选中]行
" <Leader>cs /**/产生注释
" <Leader>cu 取消注释
" <Leader>cA 调到末尾并产生注释
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"zi 打开关闭折叠
"zv 查看此行
"zm 关闭折叠
"zM 关闭所有
"zr 打开
"zR 打开所有
"zc 折叠当前行
"zo 打开当前折叠
"zd 删除折叠
"zD 删除所有折叠


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
""只有nerdtree时关闭vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
"在没有指定文件的情况下打开vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
""NERDTree快捷键
map <F9> <Esc>:NERDTreeToggle<CR> 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tagbar
nmap <F8> :TagbarToggle<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


let g:DoxygenToolkit_authorName="295421489@qq.com"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" common 
colorscheme desert
" 自定义快捷键，分割窗口resize
nmap h= :resize +5<CR>
nmap h- :resize -5<CR>
nmap v= :vertical resize +5<CR>
nmap v- :vertical resize -5<CR>

" vim-go custom mappings
au FileType go nmap s (go-implements)
au FileType go nmap i (go-info)
au FileType go nmap gd (go-doc)
au FileType go nmap gv (go-doc-vertical)
au FileType go nmap r (go-run)
au FileType go nmap b (go-build)
au FileType go nmap t (go-test)
au FileType go nmap c (go-coverage)
au FileType go nmap ds (go-def-split)
au FileType go nmap dv (go-def-vertical)
au FileType go nmap dt (go-def-tab)
au FileType go nmap e (go-rename)
" vim-go settings
let g:go_fmt_command = "goimports"

set nu
set nobackup
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

set textwidth=78
set fileformats=unix,dos
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
autocmd FileType php setlocal omnifunc=phpcomplete#Complete
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




set tags+=/home/liuqing/WorkBench/source.gateway-worker/tags
syntax on 
set backspace=indent,eol,start
set incsearch
set ruler
