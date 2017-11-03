let g:iswindows = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Judge current process is vim or gvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
	let g:isGUI = 1
else
	let g:isGUI = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=1000

" set to auto read when a file is changed outside
set autoread

" with a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

"编辑vimrc之后，重新加载
if g:iswindows
	autocmd! bufwritepost _vimrc source $VIM/_vimrc
else
	autocmd! bufwritepost *.vimrc source $HOME/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set 8 lines to the cursor - when moving vertically using j/k
" j/k移动时光标距离文件上下n行 缩写 set so = 8
set scrolloff=8

" gVim automatically maximize when it open
" 启动时最大化gVim
" http://superuser.com/questions/140419/how-to-start-gvim-maximized
if g:iswindows
	au GUIEnter * simalt ~x
endif

" 如下命令使鼠标用起来象微软 Windows
" behave mswin

" 高亮整行 只在普通模式下开启
set cursorline 

" always show current position
set ruler

" height of the command bar
set cmdheight=2

" in many terminal emulators the mouse works just fine, thus enable it
if has('mouse')
	set mouse=a
endif

" Ignore case when searching 忽略大小写
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" for regular expressions turn magic on
set magic

set showcmd

if has('multi_byte_ime')
	"未开启IME时光标背景色
	hi Cursor guifg=bg guibg=Orange gui=NONE
	"开启IME时光标背景色
	hi CursorIM guifg=NONE guibg=Skyblue gui=NONE
	" 关闭Vim的自动切换IME输入法(插入模式和检索模式)
	set iminsert=0 imsearch=0
	" 插入模式输入法状态未被记录时，默认关闭IME
	"inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"语法高亮
syntax on

" using monokai color
" there should be molokai.vim file under ~/vimfile/colors/
" https://github.com/tomasr/molokai
colorscheme molokai

"vim内部编码
set encoding=utf-8
" set current file encoding
set fileencoding=utf-8
"按照utf-8 without bom，utf-8，顺序识别打开文件
set fileencodings=ucs-bom,utf-8,gbk,gb2312,cp936,gb18030,big5,shift-jis,euc-jp,enc-kr,latin1

"防止菜单乱码
if(g:iswindows && g:isGUI)
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
endif
"默认以双字节处理那些特殊字符
if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif

set nobomb "不自动设置字节序标记

if g:iswindows
	set guifont=Courier\ New\:h12
	" set guifont=Droid\ Sans\ Mono\ for\ Powerline\:h12
	set guifontwide=NSimsun\:h12
elseif has("gui_gtk2")
	set guifont=Consolas\ 12
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
" no backup file, no write backup file, no swap file
set nobackup
set nowb
set noswapfile

" Turn off undo file, keep annoying "un~" file away
set noundofile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
set nocompatible
"设置自动缩进
set autoindent

"C语言自动缩进
set cindent
"设置Tab缩进4格
set tabstop=4

" 设置">"操作符 缩进，增加的缩进量是使用'shiftwidth'指定，默认是8
set shiftwidth=4

" 将tab自动转为空格
set expandtab

"显示行号
set nu

" set smart indent
set si
" wrap lines
set wrap

" YAML
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2

" Web
autocmd Filetype json setlocal tabstop=2 shiftwidth=2
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2
autocmd Filetype html setlocal tabstop=2 shiftwidth=2
autocmd Filetype css setlocal tabstop=2 shiftwidth=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 左下角显示当前vim模式
set showmode

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
"状态栏显示内容
"define 3 custom highlight groups
hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
hi User2 ctermbg=gray   ctermfg=blue  guibg=gray   guifg=blue
hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green

" always show the status line
set laststatus=2
set statusline=
" full filename	modified flag	read only flag 	help file flag	Preview
set statusline=%1*%F%m%r%h%w\ 
set statusline+=%2*[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y		"file type
set statusline+=%=		"divider left/right separator"
set statusline+=%3*%c,		"column
set statusline+=%l/%L	"line no/all line"
set statusline+=\ %P

" 在普通模式下用块状光标，在插入模式下用条状光标（形状类似英文 "I"
" 的样子），然后在替换模式中使用下划线形状的光标。
" if has("autocmd")
"   au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
"   au InsertEnter,InsertChange *
"     \ if v:insertmode == 'i' | 
"     \   silent execute '!echo -ne "\e[6 q"' | redraw! |
"     \ elseif v:insertmode == 'r' |
"     \   silent execute '!echo -ne "\e[4 q"' | redraw! |
"     \ endif
"   au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
" endif
" 
" if &term =~ "xterm\\|rxvt"
"   " use an orange cursor in insert mode
"   let &t_SI = "\<Esc>]12;orange\x7"
"   " use a red cursor otherwise
"   let &t_EI = "\<Esc>]12;gray\x7"
"   silent !echo -ne "\033]12;gray\007"
"   " reset cursor when vim exits
"   autocmd VimLeave * silent !echo -ne "\033]112\007"
"   " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
" endif
" 
" autocmd InsertLeave,WinEnter * set cursorline
" autocmd InsertEnter,WinLeave * set nocursorline


" powerline
" hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256
" let g:Powerline_symbols='fancy'


" general mapping
" no <up> ddkP
" no <down> ddp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" =>Others
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
	\    exe "normal! g`\"" |
    \ endif

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" 依据 https://stackoverflow.com/a/8218188/1820217 将 Plugin map
" 移到最后，使得 leader 生效
" 引用vundle_vimrc
" 引用python_vimrc配置文件
if g:iswindows
	source $VIM/vundle_vimrc
	source $VIM/python_vimrc
else
	source $HOME/.vim/startup/vundle_vimrc
	source $HOME/.vim/startup/python_vimrc
	source $HOME/.vim/startup/map_vimrc
	source $HOME/.vim/startup/plugin_vimrc
endif

" source $VIMRUNTIME/vimrc_example.vim
" source $VIMRUNTIME/mswin.vim

