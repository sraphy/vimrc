set nocompatible
filetype off

" 设置编码  
set encoding=utf-8  
set fenc=utf-8  
set termencoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,gb2312,gb18030,big5 

"显示行号
set number

"设置背景色
"set bg=dark

"保存100条命令历史记录
set history=100	
	
"总是在窗口右下角显示光标的位置
set ruler

"在Vim窗口右下角显示未完成的命令 
"set showcmd

"设置语法高亮
if &t_Co > 2 || has("gui_running")
	syntax on
endif

"-------------------------------------------------------------------------------
""			文本操作设置
"-------------------------------------------------------------------------------
"设置字体
"set gfn=Courier:h15

"设置自动缩进
"设置智能缩进
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" CTRL-U 在Insert模式下可以删除当前光标所在行所在列之前的所有字符. Insert模式下，在Enter换行之后，可以立即使用CTRL-U命令删除换行符。
inoremap <C-U> <C-G>u<C-U>

"使 "p" 命令在Visual模式下用拷贝的字符覆盖被选中的字符。
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>

"-------------------------------------------------------------------------------
""			搜索设置
"-------------------------------------------------------------------------------
""打开搜索高亮
set hlsearch

"忽略大小写
set ignorecase

"在查找时输入字符过程中就高亮显示匹配点。然后回车跳到该匹配点。
set incsearch	

"设置查找到文件尾部后折返开头或查找到开头后折返尾部。
set wrapscan

"-------------------------------------------------------------------------------
""			文件设置
"-------------------------------------------------------------------------------
"设置当Vim覆盖一个文件的时候保持一个备份文件，但vms除外（vms会自动备份。备份文件的名称是在原来的文件名上加上
"~" 字符
if has("vms")
	set nobackup		 
else
	set backup		
endif

if has("autocmd")
	"启用文件类型检测并启用文件类型相关插件，不同类型的文件需要不同的插件支持，同时加载缩进设置文件,用于自动根据语言特点自动缩进.
	filetype plugin indent on
	augroup vimrcEx
	"vim启动后自动打开NerdTree
  	autocmd vimenter * NERDTree
  	autocmd vimenter * if !argc() | NERDTree | endif
  	"设置关闭vim NerdTree窗口
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif  
	augroup END
else
	"Enter换行时总是使用与前一行的缩进等自动缩进。
	set autoindent
	"设置智能缩进
	set smartindent    	
endif  

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'

" The bundles you install will be listed here
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" HOTKEY
map <C-f> :NERDTreeToggle<CR>

filetype plugin indent on

" The rest of your config follows here
" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

" HIGHLIGHT
augroup vimrc_autocmds
	autocmd!
	" highlight characters past column 120
	autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
	autocmd FileType python match Excess /\%120v.*/
	autocmd FileType python set nowrap
	augroup END

" -------------------------------
"  Python 设置
" -------------------------------
" HotKey to Complier
map <F5> <ESC>:w<CR>:call RunOneFile()<CR>
function! RunOneFile()
    if &filetype=='vim'
        source %
    elseif &filetype=='python'
        if expand('%:e')=='py3'
            !python3 %
        else
            !python %
        endif
    elseif &filetype=='c'
        if exists('g:ccprg')
            let b:ccprg = g:ccprg
        else
            let b:ccprg = 'gcc'
        endif
        exe '!' . b:ccprg . ' "' . expand('%:p') . '" -o "' . expand('%:p:r') . '"'
        exe '!' . expand('%:p:r')
    endif
endfunction

" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 0

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Use <leader>l to toggle display of whitespace
nmap <leader>l :set list!<CR>
" automatically change window's cwd to file's dir
set autochdir

" I'm prefer spaces to tabs
set tabstop=4
set shiftwidth=4
set expandtab

" more subtle popup colors 
if has ('gui_running')
	highlight Pmenu guibg=#cccccc gui=bold    
endif

" JEDI SETTING
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 1
let g:jedi#show_call_signatures = "1"
let g:jedi#completions_enabled = 1
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"

function HeaderPython()
        call setline(1, "#!/usr/bin/env python3")
        call append(1, "# -*- coding: utf-8 -*-")
        call append(2, "# sraphy @ " . strftime('%Y-%m-%d %T', localtime()))
        normal G
        normal o
        normal o
endf

autocmd bufnewfile *.py call HeaderPython()
"autocmd BufNewFile *.py 0r $VIMFILES/template/template.py
