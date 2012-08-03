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
let g:my_plugin_repos = [{'name': 'jst', 'settings': { 'type' : 'git', 'url' : 'git://github.com/briancollins/vim-jst' }}]
                                                    " CORE
call add(g:my_vim_plugins,  'The_NERD_tree'       ) "   file tree
call add(g:my_vim_plugins,  'ctrlp'               ) "   fuzzy finder
call add(g:my_vim_plugins,  'ack'                 ) "   a multi-file search utility

                                                    " NICETIES
call add(g:my_vim_plugins,  'matchit.zip'         ) "   better % matching
call add(g:my_vim_plugins,  'YankRing'            ) "   copy paste history

call add(g:my_vim_plugins,  'bufkill'             ) "   close file but not window
call add(g:my_vim_plugins,  'fugitive'            ) "   the git plugin
call add(g:my_vim_plugins,  'surround'            ) "   wrap text easily

                                                    " LANGUAGES
call add(g:my_vim_plugins,  'VimClojure'          ) "   clojure
call add(g:my_vim_plugins,  'jst'                 ) "   Underscore.js Templates
call add(g:my_vim_plugins,  'haml.zip'            ) "   HAML and SASS
call add(g:my_vim_plugins,  'vim-coffee-script'   ) "   Coffeescript

                                                    " COLORS
call add(g:my_vim_plugins,  'molokai'             ) "  dark and colorful
call add(g:my_vim_plugins,  'inkpot'              ) "  dark and blue-ish
call add(g:my_vim_plugins,  'Solarized'           ) "  the only light scheme I like

" }}}
" VAM {{{
function! EnsureVamIsOnDisk(vam_install_path)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
  if eval(is_installed_c)
    return 1
  else
    call mkdir(a:vam_install_path, 'p')
    "execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
    execute '!git clone --depth=1 git://github.com/rocksolidwebdesign/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'

    exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
    return eval(is_installed_c)
  endif
endfunction

function! MyExtraVamRepos()
  let d = vam#install#Pool()

  for repo in g:my_plugin_repos
    let d[repo['name']] = repo['settings']
  endfor

  " the old way of doing it
  " let d['jst'] = { 'type' : 'git', 'url' : 'git://github.com/briancollins/vim-jst.git' }

  return d
endfunction

function! SetupVAM()
  let g:vim_addon_manager = {'shell_commands_run_method': 'system','auto_install': 1, 'known_repos_activation_policy': 'always'}
  let g:vim_addon_manager.pool_fun = function('MyExtraVamRepos')

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
  " silent! vam#ActivateAddons(g:my_vim_plugins, {'auto_install' : 1})
  let g:vam_silent_log = 1
  call vam#ActivateAddons(g:my_vim_plugins)
  unlet g:vam_silent_log
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
endfunction

call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]
" }}}

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
    colorscheme molokai
    hi Folded guifg=#dddddd guibg=#1B1D1E

    "colorscheme inkpot
    "hi Folded guibg=#1c314c guifg=#dddddd

    "colorscheme solarized
    "set background=light
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
"autocmd FileType xml,xhtml,html,php,phtml,eruby,jst runtime scripts/closetag.vim

autocmd BufRead  *.handlebars set ft=handlebars
autocmd BufRead  *.tpl        set ft=jst
autocmd BufRead  *.as         set ft=actionscript
autocmd BufRead  *.mxml       set ft=mxml
autocmd BufRead  *.conf       set ft=apache
autocmd BufRead  *.phtml      set ft=php
autocmd BufRead  *.wsgi       set ft=python
autocmd BufWrite *.wsgi       set ft=python
autocmd BufRead  *.haml.js    set ft=haml
autocmd BufRead  *.jst.haml   set ft=haml
autocmd BufRead  *            set sts=2 sw=2
" }}}
" Key Mappings {{{
let maplocalleader = "_"

" fast .vimrc access
nnoremap <Leader>v :e ~/.vimrc<CR>
nnoremap <Leader>o :source ~/.vimrc<CR>

" toggles
let g:ctrlp_map = '<Leader>p'

"nnoremap <Leader>p :CtrlP<CR>
nnoremap <Leader>f :botright copen<CR>
nnoremap <Leader>x :cclose<CR>
nnoremap <Leader>t :TlistToggle<CR>
nnoremap <Leader>d :NERDTree ~/Desktop<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>b :NERDTree
nnoremap <Leader>h :set hls!<CR>
nnoremap <Leader>r :call ToggleRelativeNumber()<CR>
vnoremap <Leader>r :call ToggleRelativeNumberVisual()<CR>
nnoremap <Leader>w :call ToggleWrap()<CR>
nnoremap <Leader>m :call ToggleMousePaste()<CR>
nnoremap <Leader>z :syntax on<CR>

" filters
nnoremap <Leader>q {v}!par -jw
vnoremap <Leader>q !par -jw
vnoremap <Leader>a !perl ~/.vim/bin/align.pl -c:=
nnoremap <Leader>s :call StripWhitespace()<CR>

" javascript specific stuff
nnoremap <Leader>jsb :call JsBeautify()<CR>
vnoremap <Leader>jsb :call JsBeautifyRange()<CR>

nnoremap <Leader>jsy ^yypysiW)kysiW"ysiW)^iconsole.log<ESC>j^.$a;<ESC>k$a;<ESC>
nnoremap <Leader>jsl ^v$hS"gvS)^iconsole.log<ESC>$a;<ESC>
vnoremap <Leader>jsl S"gvS)^iconsole.log<ESC>$a;<ESC>

" auto insert curly braces on Control-F
inoremap <C-F> {<CR>}<C-O>O

" alt key substitutions for normal style
" editor things like copy paste save
" close and quit
nnoremap <M-q> :qa!<CR>
nnoremap <M-v> "+P
nnoremap <M-V> "+p
vnoremap <M-c> "+y
vnoremap <M-x> "+x
nnoremap <M-s> :w<CR>
nnoremap <M-w> :BD<CR>
nnoremap <M-W> :bd<CR>
nnoremap <M-n> :bn<CR>
nnoremap <M-p> :bp<CR>

" show and hide the menubar, toolbar and scrollbar respectively
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" override spacebar to open and close folds
nnoremap <space> :call ToggleFold()<CR>

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
    normal gv
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
" }}}
