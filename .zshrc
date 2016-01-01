# General ZSH options {{{
autoload -U colors && colors
autoload -Uz promptinit && promptinit
# prompt fire

h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vim
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}

# more vim like bindings for vi edit mode
#source ~/.zsh_vim_mode.zsh

# custom functions
knife() {
    echo "Running Knife with your ENV settings..."

    HOME="$HOME" CHEF_USER="$CHEF_USER" CHEF_ORG="$CHEF_ORG" CHEF_NODE="$CHEF_NODE" CHEF_KEY="$CHEF_KEY" CHEF_REGION="$CHEF_REGION" "$HOME/.rvm/gems/ruby-1.9.3-p194/bin/knife" $@
}

# Prompt {{{
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# ░▒▓██▓▒░
setPrompt() {
    PS1="
%b%F{green}%K{black}%{░▒▓%}%b%F{green}%K{blue}%{█▓▒░%}%B%F{white}%K{blue}%n@%m%b%F{green}%K{blue}%{░▒▓██%}%b%F{green}%K{black}%{▓▒░%}%B%F{white}%K{black} %D{%H:%M:%S}%b%f%k %B%{$fg[magenta]%} ( $(parse_git_branch) )%b%f%k
%}%b%f%k %(?,%F{green}:%),%F{yellow}%? %F{red}:()%f %# "
    #PS1="%{$fg[green]%}%n%{$fg[blue]%}@%{$fg[green]%}%m%{$fg[magenta]%}$(parse_git_branch)%{$reset_color%}%# "
    RPS1="%B%F{blue}%K{black}%~%{$reset_color%}"
}

precmd() {
    setPrompt
}
# }}}
# Aliases {{{
alias ls="ls -CF --color"
alias ll="ls"
alias l="ls -lh"
alias la="ls -A"
alias lv="ls -lhA"

# git
alias git='noglob git'

alias gf='git fetch origin'
alias gs='git status'
alias gd='git diff'

alias ga='git add'
alias gal='git add -A'

alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'
alias gsa='git stash apply'

alias gcm='git commit -m'
alias gcam='git commit -a -m'

alias gp='git push -u origin HEAD'
alias gpf='git push --force origin HEAD'

alias gu='git fetch origin; git merge --ff-only origin/$(parse_git_branch)'
alias gr='git fetch origin; git rebase origin/$(parse_git_branch)'

# if the fast forward of master is successful, we'll then
# rebase the current branch on to our local copy of master
alias grm='git fetch origin master:master && git rebase master'
# }}}
# Environment Vars {{{

export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/gvim

# personal
export PATH="$HOME/bin:$PATH"

# nodejs
export PATH="$PATH:$HOME/install/node-v0.12.7-linux-x64/bin" # Add RVM to PATH for scripting
#export PATH="$PATH:$HOME/install/node-v4.2.1-linux-x64/bin" # Add RVM to PATH for scripting

# haskell
export PATH="$HOME/.cabal/bin:/opt/cabal/head/bin:/opt/ghc/7.8.4/bin:$PATH"

# wine
export WINEPREFIX=$HOME/.wine
export WINEARCH=win32

# scala
export SCALA_HOME="$HOME/install/scala-2.11.7"
export PATH="$SCALA_HOME/bin:$PATH"

# maven
export PATH="$HOME/install/apache-maven-3.3.3/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#export QT_SELECT="qt5-x86_64-linux-gnu"
#export QT_SELECT="qt4-x86_64-linux-gnu"

[ -n "$TMUX" ] && export TERM=screen-256color
# }}}

# personal modifications
source $HOME/.zshrc_local
