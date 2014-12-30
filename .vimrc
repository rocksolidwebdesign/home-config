call pathogen#infect()

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Font and Colorscheme {{{
if has("gui_running")
  if has("win32")
    set gfn=DejaVu_Sans_Mono:h8:cANSI
  elseif has("unix")
    if has("macunix")
      set gfn=DejaVu\ Sans\ Mono:h18
    else
      set gfn=DejaVu\ Sans\ Mono\ 14
    endif
  endif

  colorscheme solarized
  set background=light

  "colorscheme molokai
  "hi Folded guifg=#dddddd guibg=#1B1D1E

  "colorscheme softlight
  "hi Special gui=NONE guifg=#0E8ED3 guibg=#ffffff

  "colorscheme softblue

  "colorscheme google
  "hi Statement guifg=#2a5db0 guibg=#ffffff gui=bold
else
  if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
  endif

  colorscheme molokai
  hi Folded guifg=#dddddd guibg=#1B1D1E

  "colorscheme inkpot
  "hi Folded guibg=#1c314c guifg=#dddddd

  set mouse=a
end
" }}}

" Option Settings {{{
set hidden
set wildmenu
set nocompatible
set number
set ruler
set showcmd
set autoread

" handle gui settings and platform discrepancies
"if &encoding ==# 'latin1' && has('gui_running')
"  set encoding=utf-8
"endif

set list

" I  like this personally
set listchars=tab:\⇒\─,trail:\‣,extends:\↷,precedes:\↶

" But for example, you might like something like this
" set listchars=tab:\→\ ,trail:\‣,extends:\↷,precedes:\↶
"
" Or something more cluttered, like this
" set listchars=tab:\↴\⇒,trail:\⎕,extends:\↻,precedes:\↺,eol:\↵
"
" Or something more prominent but still thin and line oriented
" set listchars=tab:\┼\─,trail:\˽,extends:\↷,precedes:\↶

" spaces, no tabs
set tabstop=8
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

if !&scrolloff
  set scrolloff=1
endif

if !&sidescrolloff
  set sidescrolloff=5
endif

" search
set ignorecase
set smartcase
set incsearch
set nohlsearch
set nowrap

" window splits
set winminheight=0
set winminwidth=0

" keys
set backspace=2
set whichwrap=b,s,h,l,[,],<,>

" misc
set foldmethod=marker
set display=lastline,uhex
set sessionoptions+=resize

set laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%{fugitive#statusline()}%=%-16(\ %l,%c\ %)%P

" Sophisticated Swap Files
if has("win32")
  if exists("my_diff_mode_flag") && my_diff_mode_flag == 1
    set directory=C:\WINDOWS\Temp,~\tmp,~,~\vimfiles\swpdiff,.
  else
    set directory=C:\WINDOWS\Temp,~\tmp,~,~\vimfiles\swp,.
  endif
elseif has("unix")
  if exists("my_diff_mode_flag") && my_diff_mode_flag == 1
    set directory=/tmp,~/.swpdiff,~/tmp,~/.vim/.swpdiff,~/.vim/swpdiff,~,.
  else
    set directory=/tmp,~/.swp,~/tmp,~/.vim/.swp,~/.vim/swp,~,.
  endif
endif
" }}}

" Plugin Settings {{{
" /usr/lib/llvm-3.2/lib/libclang.so.1
let g:clang_library_path = "/usr/lib/llvm-3.2/lib"

" prevent annoying warnings from nerdtree
let g:NERDShutUp = 1

" don't load the matchparen plugin
let loaded_matchparen = 1

" filetype plugin settings
let g:no_html_tab_mapping = 1 " let me insert tabs when i press the freakin tab key!
let g:html_tag_case = 'lowercase'

" use a vertical window split
let g:yankring_window_use_horiz   = 0

" don't include single character deletes
let g:yankring_min_element_length = 2

" truncate each paste at 50 chars to keep the window width small
let g:yankring_max_display        = 50

" don't bother to colorize end tags differently
" based on what type of block is being ended
" hopefully this means faster loads and better
" syntax hilite with folds
let ruby_no_expensive = 1
" }}}

" Auto Commands {{{
" keep relative line number on permanently/by default
autocmd BufNew,BufRead  * setlocal relativenumber
autocmd BufLeave,FocusLost * silent! wall
" }}}

" Key Mappings {{{
let maplocalleader = "\\"
let mapleader = " "

nmap <Return> <Plug>OpenNewline
nmap <S-Return> <Plug>InsertNewLine

" fast .vimrc access
nnoremap <LocalLeader>v :e ~/.vimrc<CR>
nnoremap <LocalLeader>o :source ~/.vimrc<CR>

" toggles
let g:ctrlp_map = '<Leader>p'

nnoremap <LocalLeader>f :botright copen<CR>
nnoremap <LocalLeader>x :cclose<CR>
nnoremap <LocalLeader>t :TlistToggle<CR>
nnoremap <LocalLeader>n :NERDTreeToggle<CR>
nnoremap <LocalLeader>h :set hls!<CR>
nnoremap <Return>       :call ToggleFold()<CR>
nnoremap <LocalLeader>r :call ToggleRelativeNumber()<CR>
vnoremap <LocalLeader>r :call ToggleRelativeNumberVisual()<CR>
nnoremap <LocalLeader>w :call ToggleWrap()<CR>
nnoremap <LocalLeader>m :call ToggleMousePaste()<CR>
nnoremap <LocalLeader>z :syntax on<CR>
nnoremap <LocalLeader>yr :YRShow<CR>
nnoremap <LocalLeader>yc :YRClear<CR>
nnoremap <LocalLeader>y1 :YRGetElem 1<CR>
nnoremap <LocalLeader>y2 :YRGetElem 2<CR>
nnoremap <LocalLeader>y3 :YRGetElem 3<CR>
nnoremap <LocalLeader>y4 :YRGetElem 4<CR>
nnoremap <LocalLeader>y5 :YRGetElem 5<CR>
nnoremap <LocalLeader>y6 :YRGetElem 6<CR>
nnoremap <LocalLeader>y7 :YRGetElem 7<CR>
nnoremap <LocalLeader>y8 :YRGetElem 8<CR>
nnoremap <LocalLeader>y9 :YRGetElem 9<CR>
nnoremap <LocalLeader>y0 :YRGetElem 10<CR>

" filters
nnoremap <LocalLeader>q {v}!par -jw
vnoremap <LocalLeader>q !par -jw
vnoremap <LocalLeader>a !perl ~/.vim/bin/align.pl -c:=
nnoremap <LocalLeader>s :call StripWhitespace()<CR>

" javascript specific stuff
nnoremap <Leader>jsb :call JsBeautify()<CR>
vnoremap <Leader>jsb :call JsBeautifyRange()<CR>

" js [Y]ourself, output a token's name and it's value
nmap <Leader>jsy ^yypysiW)kysiW"ysiW)^iconsole.log<ESC>j^.$a;<ESC>k$a;<ESC>
nmap <Leader>jsl ^v$hS"gvS)^iconsole.log<ESC>$a;<ESC>
vmap <Leader>jsl S"gvS)^iconsole.log<ESC>$a;<ESC>
nmap <Leader>jsf o'': function() {<CR>},<CR><ESC>kOvar view;<CR><CR>view = this;<CR><ESC>5k0wa
nmap <Leader>jsc ifunction() {<CR>}<ESC>k/function<CR>f(a

" Java
nmap <Leader>jay ^yypysiW)kysiW"ysiW)^iSystem.out.println<ESC>j^.$a;<ESC>k$a;<ESC>
nmap <Leader>jal ^v$hS"gvS)^iSystem.out.println<ESC>$a;<ESC>
vmap <Leader>jal S"gvS)^iSystem.out.println<ESC>$a;<ESC>

" [W]ow, that's a big string you have
nmap <Leader>ryw diWoputs "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<ESC>opp <ESC>pkk:s/^\s*\n//<CR>oputs "<ESC>pa"<ESC>kk:s/^\s*\n//<CR>
nmap <Leader>ryo oputs "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<ESC>

" [E]xpression var dump, output a tokens's name and it's value
nmap <Leader>rye yiWyss}i#<ESC>vl%S"pa: <ESC>^iputs <ESC>

" [I]nterpolate, wrap a single strict word like this #{foo}
nmap <Leader>ryi viwS}i#<ESC>
vmap <Leader>ryi S}i#<ESC>

" output an entire line of text
nmap <Leader>ryl ^v$hS"^iputs <ESC>
vmap <Leader>ryl S"gvS"^iputs <ESC>

nmap <LocalLeader>pdv ysiW(^iecho "<pre>"; var_dump<ESC>$a; exit;<ESC>
nmap <LocalLeader>pdf ysiW(ysi((iget_class_methods<ESC>^iecho "<pre>"; var_dump<ESC>$a; exit;<ESC>

" auto insert curly braces on Control-F
inoremap <C-F> {<CR>}<C-O>O

" alt key substitutions for normal style
" editor things like copy paste save
" close and quit
nnoremap <M-q> :qa!<CR>
nnoremap <M-a> ggVG
nnoremap <M-v> "+P
nnoremap <M-V> "+p
vnoremap <M-c> "+y
vnoremap <M-x> "+x
nnoremap <M-s> :w<CR>
nnoremap <M-w> :BD<CR>
nnoremap <M-W> :bd<CR>
nnoremap <M-n> :bn<CR>
nnoremap <M-p> :bp<CR>

nnoremap <M-1> :YRGetElem 1<CR>
nnoremap <M-2> :YRGetElem 2<CR>
nnoremap <M-3> :YRGetElem 3<CR>
nnoremap <M-4> :YRGetElem 4<CR>
nnoremap <M-5> :YRGetElem 5<CR>
nnoremap <M-6> :YRGetElem 6<CR>
nnoremap <M-7> :YRGetElem 7<CR>
nnoremap <M-8> :YRGetElem 8<CR>
nnoremap <M-9> :YRGetElem 9<CR>
nnoremap <M-0> :YRGetElem 10<CR>

" show and hide the menubar, toolbar and scrollbar respectively
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" make indentation easier by default
nnoremap < <<
nnoremap > >>

" make indentation keep selection intact
vnoremap > >gv
vnoremap < <gv

nnoremap <C-e> j<C-e>
nnoremap <C-y> k<C-y>

" }}}

" Functions {{{
function! ToggleMousePaste()
  if &mouse == 'a'
    set paste
    set mouse=
    set nonumber
    echo 'Mouse Paste ON'
  else
    set nopaste
    set number
    set mouse=a
    echo 'Mouse Paste OFF'
  endif
endfunction

function! ToggleRelativeNumberVisual()
  call ToggleRelativeNumber()
  normal gvj
endfunction

function! ToggleRelativeNumber()
  if( &nu == 1 )
    set nonu
    set rnu
  else
    set nu
    set nornu
  endif
endfunction

function! ToggleWrap()
  set wrap!

  if( &wrap == 1 )
    nmap j gj
    nmap k gk
  else
    unmap j
    unmap k
  endif
endfunction

function! ToggleFold()
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  " Clear status line
  echo
endfunction

function! StripWhitespace()
  let currPos=Mark()
  exe 'v:^--\s*$:s:\s\+$::e'
  exe currPos
endfunction

function! Mark(...)
  if a:0 == 0
    let mark = line(".") . "G" . virtcol(".") . "|"
    normal! H
    let mark = "normal!" . line(".") . "Gzt" . mark
    execute mark
    return mark
  elseif a:0 == 1
    return "normal!" . a:1 . "G1|"
  else
    return "normal!" . a:1 . "G" . a:2 . "|"
  endif
endfunction
" }}} Functions 
