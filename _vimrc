" 引用vundle_vimrc
source $VIM/vundle_vimrc

" 引用python_vimrc配置文件
source $VIM/python_vimrc


source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim

" 如下命令使鼠标用起来象微软 Windows
behave mswin

" using monokai color
" there should be molokai.vim file under ~/vimfile/colors/
" https://github.com/tomasr/molokai
colorscheme molokai

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

"vim内部编码
set encoding=utf-8
"按照utf-8 without bom，utf-8，顺序识别打开文件
set fileencodings=ucs-bom,utf-8,gbk,gb2312,cp936,big5,gb18030,shift-jis,latin1

set fileencoding=utf-8

"防止菜单乱码
if(has("win32") || has("win64") || has("win95") || has("win16"))
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
endif
"默认以双字节处理那些特殊字符
if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    set ambiwidth=double
endif

set nobomb "不自动设置字节序标记

set guifont=Courier\ New\:h12
set guifontwide=NSimsun\:h12

set nocompatible "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
"设置自动缩进
set autoindent
"C语言自动缩进
set cindent
"设置Tab缩进4格
set tabstop=4
"显示行号
set nu

"语法高亮
syntax on

set ruler
"状态栏显示内容
"define 3 custom highlight groups
hi User1 ctermbg=green ctermfg=red   guibg=green guifg=red
hi User2 ctermbg=gray   ctermfg=blue  guibg=gray   guifg=blue
hi User3 ctermbg=blue  ctermfg=green guibg=blue  guifg=green
 
set laststatus=2
set statusline=
"full filename	modified flag	read only flag 	help file flag	Preview
set statusline=%1*%F%m%r%h%w\ 
set statusline+=%2*[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y		"file type
set statusline+=%=		"divider left/right separator"
set statusline+=%3*%c,		"column
set statusline+=%l/%L	"line no/all line"
set statusline+=\ %P


set showcmd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile



" Plugin settings
" NERDTree
map <F2> :NERDTreeToggle<cr>

" plasticboy/vim-markdown
" disable folding
let g:vim_markdown_folding_disabled=1
" Highlight YAML frontmatter as used by Jekyll
let g:vim_markdown_frontmatter=1

" intend guides
let g:indent_guides_enable_on_vim_startup = 1

" jedi-vim plugin config
let g:jedi#completions_command = "<C-N>"
let g:jedi#popup_on_dot = 0


set diffexpr=MyDiff()
function MyDiff()
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

