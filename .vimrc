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

" Active Plugins {{{
let g:my_vim_plugins  = []
let g:my_plugin_repos  = []

call add(g:my_plugin_repos, {'name': 'jst', 'settings': { 'type' : 'git', 'url' : 'git://github.com/briancollins/vim-jst' }})
" }}}
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
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager['log_to_buf'] =1

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
  call vam#ActivateAddons(['The_NERD_tree', 'ctrlp', 'ack', 'matchit.zip', 'YankRing', 'bufkill', 'surround', 'haml.zip', 'molokai', 'inkpot', 'Solarized'], {'auto_install' : 1})
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
call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

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

" spaces, no tabs
set expandtab

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
" set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c\ %)%P
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

 " Plugin Settings {{{

" prevent annoying warnings from nerdtree
let g:NERDShutUp = 1

" don't load the matchparen plugin
let loaded_matchparen = 1

" filetype plugin settings
let g:no_html_tab_mapping = 1 " let me insert tabs when i press the freakin tab key!
let g:html_tag_case = 'lowercase'
let g:sql_type_default = 'pgsql'
let g:miniBufExplTabWrap = 1

let g:insertlessly_cleanup_trailing_ws = 0
let g:insertlessly_cleanup_all_ws = 0

"let g:php_sync_method = 0
let g:php_sync_method = 100

" taglist plugin settings
let Tlist_Auto_Highlight_Tag = 0
let Tlist_Sort_Type = "name"
let Tlist_Highlight_Tag_On_BufEnter = 0
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 'auto'

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

" JRuby Load-Speed Fix
" if !empty(matchstr($MY_RUBY_HOME, 'jruby'))
if !empty(matchstr($MY_RUBY_HOME, 'jruby'))
  "let g:ruby_path = join(split(glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".glob($MY_RUBY_HOME.'/lib/ruby/site_ruby/*'),"\n"),',')
  "let g:ruby_path = join(split(glob($MY_RUBY_HOME.'/lib/ruby/*.*')."\n".glob($MY_RUBY_HOME.'/lib/ruby/site_ruby/*')."\n".glob($GEM_HOME.'*/**/lib'),"\n"),',')

  " hardcoding this for speed, do  it this way if you're new
  " and need to  figure out what your paths  actually are or
  " maybe if you need to add or change some gems

  " bare minimum  basics for a nicer/faster  startup time, I
  " don't personally use any of  the gem related features of
  " the ruby plugin that I'm aware
  let g:ruby_path = '/home/vaughn/.rvm/rubies/jruby-1.6.7.2/lib/ruby/1.9,/home/vaughn/.rvm/rubies/jruby-1.6.7.2/lib/ruby/site_ruby/shared'
endif
" }}}

" GUI vs Console {{{
" ****************************************************************
set winaltkeys=no

" Unbreak Unix style mouse selection -> copy
"vnoremap <LeftRelease> "+y<LeftRelease>gv

" tab display
if v:version >= 700
    set guitablabel=%L\ %t\ %h
    set guitabtooltip=%f
endif

" Setup Toolbars
set guioptions=ti " with menubar and toolbar and tearoffs

" Set Font
if has("win32")
    set gfn=DejaVu_Sans_Mono:h8:cANSI
elseif has("unix")
  if has("macunix")
    set gfn=DejaVu\ Sans\ Mono:h11
  else
    set gfn=DejaVu\ Sans\ Mono\ 9
  endif
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
    "colorscheme molokai
    "hi Folded guifg=#dddddd guibg=#1B1D1E

    colorscheme inkpot
    hi Folded guibg=#1c314c guifg=#dddddd

    "colorscheme solarized
    "set background=light

    "set t_Co=256
    set mouse=a
endif
" }}}

" Auto Commands {{{
"autocmd FileType xml,xhtml,html,php,phtml,eruby,jst runtime scripts/closetag.vim

autocmd BufNew,BufRead  *.handlebars setlocal ft=handlebars
autocmd BufNew,BufRead  *.as         setlocal ft=actionscript
autocmd BufNew,BufRead  *.mxml       setlocal ft=mxml
autocmd BufNew,BufRead  *.conf       setlocal ft=apache
autocmd BufNew,BufRead  *.phtml      setlocal ft=php
autocmd BufNew,BufRead  *.wsgi       setlocal ft=python
autocmd BufNew,BufWrite *.wsgi       setlocal ft=python
autocmd BufNew,BufRead  *.haml.js    setlocal ft=haml
autocmd BufNew,BufRead  *.jst.haml   setlocal ft=haml
autocmd BufNew,BufRead  *            setlocal relativenumber
" }}}

 " Key Mappings {{{
let maplocalleader = "-"
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

" [W]ow, that's a big string you have
nmap <Leader>ryw diWoputs "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"<ESC>opp <ESC>pkk:s/^\s*\n//<CR>
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

function! JsBeautify()
  " Things `js-beautify` does not do
  " ****************************************************************
  " line breaks between class definitions
  %s/^}\s*)\s*;\(\s*\n\)*/});\r\r/g

  " line breaks between function definitions
  %s/^  }\s*,\(\s*\n\)*/  },\r\r/g

  " change $(this.el) to this.$el
  %s/$(\s*\(this\|cmp\)\s*\.\s*el\s*)/\1.$el/g

  " Run `js-beautify`
  " ****************************************************************
  %!myjsbeautify -

  " Things to change
  " ****************************************************************
  " put opening function braces of underscore style closures back on the same line
  %s/\(_\.[a-zA-Z0-9_]\+(.\{-}function\s([^{]*\)\s*\n\s*{\(\s*\n\)*/\1 {\r/
  %s/\(_\.\s*extend\*([^{]*\)\s*\n\s*{\(\s*\n\)*/\1 {\r/

  " put opening function braces of other closures back on the same line
  %s/\((.\{-}function\s*[^{]*\)\(\s*\n\)*\s*{\(\s*\n\)*/\1 {\r/g

  " put opening braces of foo({ bar: baz }) type calls back on the same line
  %s/^\(\(.\(function\|if\|else\|while\|for\|try\|catch\|switch\)\@!\)*\)(\s*\n\s*{/\1({/

  " catch those pesky object extenders
  %s/\(_\.\s*extend\s*([^;]\+\)\(\s*\n\)\+\s*{\(\s*\n\)*/\1 {\r/

  " normalize line breaks
  %s/\(\s*\n\)\{3,}/\r\r/g
endfunction

function! JsBeautifyRange() range
  " Things `js-beautify` does not do
  " ****************************************************************
  " line breaks between class definitions
  '<,'>s/^}\s*)\s*;\(\s*\n\)*/});\r\r/g

  " line breaks between function definitions
  '<,'>s/^  }\s*,\(\s*\n\)*/  },\r\r/g

  " change $(this.el) to this.$el
  '<,'>s/$(\s*\(this\|cmp\)\s*\.\s*el\s*)/\1.$el/g

  " Run `js-beautify`
  " ****************************************************************
  '<,'>!myjsbeautify -

  " Things to change
  " ****************************************************************
  " put opening function braces of underscore style closures back on the same line
  '<,'>s/\(_\.[a-zA-Z0-9_]\+(.\{-}function\s([^{]*\)\s*\n\s*{\(\s*\n\)*/\1 {\r/
  '<,'>s/\(_\.\s*extend\*([^{]*\)\s*\n\s*{\(\s*\n\)*/\1 {\r/

  " put opening function braces of other closures back on the same line
  '<,'>s/\((.\{-}function\s*[^{]*\)\(\s*\n\)*\s*{\(\s*\n\)*/\1 {\r/g

  " put opening braces of foo({ bar: baz }) type calls back on the same line
  '<,'>s/^\(\(.\(function\|if\|else\|while\|for\|try\|catch\|switch\)\@!\)*\)(\s*\n\s*{/\1({/

  " catch those pesky object extenders
  '<,'>s/\(_\.\s*extend\s*([^;]\+\)\(\s*\n\)\+\s*{\(\s*\n\)*/\1 {\r/

  " normalize line breaks
  '<,'>s/\(\s*\n\)\{3,}/\r\r/g
endfunction

function! UnHamlize()
  " keep things sane
  %s/'/"/g

  " normalish tags with attributes
  %s/%\([a-zA-Z].\{-}\){\(.\{-}\)}/<\1 \2>/g

  " tags with no attributes
  %s/%\([a-zA-Z]\{-}\)\(\s\+\|\n\)/<\1>\2/g

  " tags with attributes that have plain vars as values
  %s/\(\s*\):\([a-z-]\{-}\)\s*=>\s*\([^"]\{-}\)\s*,/\1\2="<%= \3 %>"/g
  %s/\(\s*\):\([a-z-]\{-}\)\s*=>\s*\([^"]\{-}\)\(\s*}\|\s*>\)/\1\2="<%= \3 %>"\4/g

  " tags with attributes that are regular strings
  %s/\(\s*\):\([a-z-]\{-}\)\s*=>\s*"\(.\{-}\)"\s*,/\1\2="\3"/g
  %s/\(\s*\):\([a-z-]\{-}\)\s*=>\s*"\(.\{-}\)"\(\s*}\|\s*>\)/\1\2="\3"\4/g

  " output tags
  %s/^\(\s*\)= \(.*\)$/\1<%= \2 %>/

  " script tags
  %s/^\(\s*\)- \(.*\)$/\1<% \2 %>/

  " interpolated variables
  %s/#{\(.\{-}\)}/<%= \1 %>/g

  " comments
  %s#^\(\s*\)/\s*\(.*\)$#\1<!-- \2 -->#

  " dangling script tags
  %s#<script\(.*\)>\s*$#<script \1></script>#
endfunction

function! Retab()
  let &tabstop = &shiftwidth
  retab
  let &tabstop = 8
endfunction
" }}}
