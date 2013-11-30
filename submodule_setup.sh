#!/bin/bash

rm -rf .vim/bundle/*

# COLORS
git submodule add git@github.com:flazz/vim-colorschemes.git   .vim/bundle/colorschemes

# PLUGINS
git submodule add git@github.com:scrooloose/nerdtree.git      .vim/bundle/nerdtree
git submodule add git@github.com:kien/ctrlp.vim.git           .vim/bundle/ctrlp
git submodule add git@github.com:tpope/vim-surround.git       .vim/bundle/surround
git submodule add git@github.com:vim-scripts/YankRing.vim.git .vim/bundle/yankring
git submodule add git@github.com:rking/ag.vim.git             .vim/bundle/silversearcher
git submodule add git@github.com:vim-scripts/bufkill.vim.git  .vim/bundle/buffkill
git submodule add git@github.com:tpope/vim-fugitive.git       .vim/bundle/fugitive
git submodule add git@github.com:flazz/vim-colorschemes.git   .vim/bundle/colorschemes
git submodule add git@github.com:scrooloose/syntastic.git     .vim/bundle/syntastic
git submodule add git@github.com:pangloss/vim-javascript.git  .vim/bundle/javascript
# git submodule add git@github.com:Shutnik/jshint2.vim.git      .vim/bundle/jshint2

# SYNTAX
git submodule add git@github.com:tpope/vim-haml.git           .vim/bundle/haml
git submodule add git@github.com:kchmck/vim-coffee-script.git .vim/bundle/coffee
git submodule add git@github.com:AndrewRadev/vim-eco.git      .vim/bundle/eco
git submodule add git@github.com:jimmyhchan/dustjs.vim.git    .vim/bundle/dustjs
git submodule add git@github.com:nono/vim-handlebars.git      .vim/bundle/handlebars
git submodule add git@github.com:jeyb/vim-jst.git             .vim/bundle/jst
git submodule add git@github.com:tpope/vim-liquid.git         .vim/bundle/liquid
git submodule add git@github.com:wavded/vim-stylus.git        .vim/bundle/stylus
git submodule add git@github.com:PProvost/vim-ps1.git         .vim/bundle/powershell
git submodule add git@github.com:derekwyatt/vim-scala.git     .vim/bundle/scala
git submodule add git@github.com:vim-scripts/VimClojure.git   .vim/bundle/clojure
