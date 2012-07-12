" Vim Addon Manager Init {{{
fun! EnsureVamIsOnDisk(vam_install_path)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
  if eval(is_installed_c)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
      " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:vam_install_path, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update 
      " plugins
      exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
    endif
    return eval(is_installed_c)
  endif
endf

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager['key'] = value

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  if !EnsureVamIsOnDisk(vam_install_path)
    echohl ErrorMsg
    echomsg "No VAM found!"
    echohl NONE
    return
  endif
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons(['The_NERD_tree','fugitive','matchit.zip','YankRing','molokai','inkpot','Solarized','ctrlp','bufkill','ack','jst','haml.zip','vim-coffee-script'], {'auto_install' : 1})
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

  " Addons are put into vam_install_path/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun

fun MyPoolFun()
  let d = vam#install#Pool()
  let d['jst'] = { 'type' : 'git', 'url' : 'git://github.com/briancollins/vim-jst.git' }
  return d
endf

let g:vim_addon_manager = {}
let g:vim_addon_manager.pool_fun = function('MyPoolFun')

call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]
" }}}

" Vim Config File
"   standard settings to keep me sane
"
" Dependencies:
"     par
"     exuberant-ctags
"     perl
"     DejaVu Sans Mono
"
" Last Modified: 11/13/2010
" ****************************************************************

filetype indent plugin on
syntax enable

" Option Settings {{{
set hidden
set wildmenu
set nocompatible
set number
set ruler
set list
"set encoding=utf8

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

" standard-ish default-ish tab behavior
set expandtab
set ts=8
set sts=4
set sw=4

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

" Sophisticated Swap Files {{{
if has("win32")
    if exists("my_diff_mode_flag") && my_diff_mode_flag == 1
        set directory=~\vimfiles\swpdiff,C:\WINDOWS\Temp,~/tmp,~,.
    else
        set directory=~\vimfiles\swpdiff,C:\WINDOWS\Temp,~/tmp,~,.
    endif
elseif has("unix")
    if exists("my_diff_mode_flag") && my_diff_mode_flag == 1
        set directory=~/.vim/swpdiff,~/.swpdiff,/tmp,~/tmp,~,.
    else
        set directory=~/.vim/swp,~/.swp,/tmp,~/tmp,~,.
    endif
endif
" }}}
" }}}
" Variable Settings {{{

" prevent annoying warnings from nerdtree
let g:NERDShutUp = 1

" don't load the matchparen plugin
let loaded_matchparen = 1

" filetype plugin settings
let g:no_html_tab_mapping = 1 " let me insert tabs when i press the freakin tab key!
let g:html_tag_case = 'lowercase'
let g:sql_type_default = 'pgsql'
let g:miniBufExplTabWrap = 1

" taglist plugin settings
let Tlist_Auto_Highlight_Tag = 0
let Tlist_Sort_Type = "name"
let Tlist_Highlight_Tag_On_BufEnter = 0
let Tlist_Use_Right_Window = 1
" }}}
" GUI vs Console {{{
" ****************************************************************
set winaltkeys=no

" Unbreak Unix style mouse selection -> copy
vnoremap <LeftRelease> "+y<LeftRelease>gv

" tab display
if v:version >= 700
    set guitablabel=%L\ %t\ %h
    set guitabtooltip=%f
endif

" Setup Toolbars
set guioptions=t " with menubar and toolbar and tearoffs

" Set Font
if has("win32")
    set gfn=DejaVu_Sans_Mono:h8:cANSI
elseif has("unix")
    set gfn=DejaVu\ Sans\ Mono\ 9
endif

" light in gvim, dark in terminal
if has("gui_running")
    "colorscheme molokai
    "hi Folded guifg=#dddddd guibg=#1B1D1E

    "colorscheme inkpot
    "hi Folded guibg=#1c314c guifg=#dddddd

    colorscheme solarized
    set background=light
else
    colorscheme molokai
    hi Folded guibg=#1c314c guifg=#dddddd

    "colorscheme inkpot
    "hi Folded guibg=#1c314c guifg=#dddddd

    "colorscheme solarized
    "set background=light

    "set t_Co=256
    set mouse=a
endif
" }}}
" Auto Commands {{{
autocmd FileType xml,xhtml,html,php,phtml,erb,jst runtime scripts/closetag.vim

autocmd BufRead  *.handlebars set ft=handlebars
autocmd BufRead  *.tpl        set ft=jst
autocmd BufRead  *.as         set ft=actionscript
autocmd BufRead  *.mxml       set ft=mxml
autocmd BufRead  *.conf       set ft=apache
autocmd BufRead  *.phtml      set ft=php
autocmd BufRead  *.wsgi       set ft=python
autocmd BufWrite *.wsgi       set ft=python
" }}}
" Key Mappings {{{
nnoremap <space> :call ToggleFold()<CR>

" show and hide the menubar, toolbar and scrollbar respectively
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" fast .vimrc access
nnoremap <Leader>e :e ~/.vimrc<CR>
nnoremap <Leader>o :source ~/.vimrc<CR>

" toggles
nnoremap <Leader>p :CtrlP<CR>
nnoremap <Leader>f :botright copen<CR>
nnoremap <Leader>x :cclose<CR>
nnoremap <Leader>t :TlistToggle<CR>
nnoremap <Leader>d :NERDTree ~/Desktop<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>b :NERDTree 
nnoremap <Leader>h :set hls!<CR>
nnoremap <Leader>r :call ToggleRelativeNumber()<CR>
vnoremap <Leader>r :call ToggleRelativeNumber()<CR>
nnoremap <Leader>w :call ToggleWrap()<CR>
nnoremap <Leader>m :call ToggleMousePaste()<CR>
nnoremap <Leader>z :syntax on<CR>

" auto insert curly braces on Control-F
imap <C-F> {<CR>}<C-O>O

" ex command for toggling hex mode - define mapping if desired
" command -bar Hexmode call ToggleHex()

" filters
nnoremap <Leader>q {v}!par -jw
vnoremap <Leader>q !par -jw
vnoremap <Leader>a !perl ~/.vim/bin/align.pl -c:=
nnoremap <Leader>s :call StripWhitespace()<CR>

" block movement
nnoremap < <<
nnoremap > >>

vnoremap > >gv
vnoremap < <gv

noremap <M-q> :qa!
noremap <M-v> "+P
noremap <M-V> "+p
noremap <M-c> "+y
noremap <M-x> "+x
noremap <M-s> :w<CR>
noremap <M-w> :BD<CR>
noremap <M-W> :bd<CR>
noremap <M-n> :bn<CR>
noremap <M-p> :bp<CR>

noremap <M-j>j :m+<CR>==
noremap <M-k>k :m-2<CR>==

inoremap <M-j>j <C-O>:m+<CR><C-O>==
inoremap <M-k>k <C-O>:m-2<CR><C-O>==
inoremap <M-h> <C-O><<
inoremap <M-l> <C-O>>>

vnoremap <M-j> :m'>+<CR>gv=gv
vnoremap <M-k> :m'<-2<CR>gv=gv
vnoremap <M-l> >gv
vnoremap <M-h> <gv
" }}}
" Functions {{{
fun! ToggleMousePaste()
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
endf

fun! ToggleRelativeNumber()
    if( &nu == 1 )
        set nonu
        set rnu
    else
        set nu
        set nornu
    endif
endf

fun! ToggleWrap()
    set wrap!

    if( &wrap == 1 )
        nmap j gj
        nmap k gk
    else
        unmap j
        unmap k
    endif
endf

fun! ToggleFold()
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
endf

fun! StripWhitespace()
    let currPos=Mark()
    exe 'v:^--\s*$:s:\s\+$::e'
    exe currPos
endf

fun! Mark(...)
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
endf
" }}}
