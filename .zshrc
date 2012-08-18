# General ZSH options {{{
autoload -U colors && colors
autoload -Uz promptinit && promptinit
# prompt fire

h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

setopt histignorealldups sharehistory

# Use vim keybindings even if our EDITOR is set to emacs
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
# {{{
parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# ░▒▓██▓▒░
setPrompt() {
    PS1="
%b%F{green}%K{black}%{░▒▓%}%b%F{green}%K{blue}%{█▓▒░%}%B%F{white}%K{blue}%n@%m%b%F{green}%K{blue}%{░▒▓██%}%b%F{green}%K{black}%{▓▒░%}%B%F{white}%K{black} %D{%H:%M:%S}%b%f%k %B%{$fg[magenta]%}$(parse_git_branch)%b%f%k
%}%b%f%k%# "
    #PS1="%{$fg[green]%}%n%{$fg[blue]%}@%{$fg[green]%}%m%{$fg[magenta]%}$(parse_git_branch)%{$reset_color%}%# "
    RPS1="%B%F{blue}%K{black}%~%{$reset_color%}"
}

precmd() {
    setPrompt
}
# }}}
# Aliases {{{
alias ls="ls -GF"
alias ll="ls"
alias l="ls -lh"
alias la="ls -A"
alias lv="ls -lhA"

# git
alias git='noglob git'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gd='git diff'
alias gf='git fetch'
alias gu='git pull'
alias gr='git pull --rebase'
alias gp='git push origin HEAD'
alias gpu='git push -u origin HEAD'
alias gpf='git push --force origin HEAD'
alias gs='git status'
alias ga='git add'
alias gal='git add -A'
alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'
alias gsa='git stash apply'
# }}}
# Environment Vars {{{
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

#export TERM=xterm-256color
export EDITOR=$HOME/.bin/vim
export VISUAL=$HOME/.bin/vim

export ANDROID_HOME=/media/user/Library/android-sdk-linux
export PATH=$HOME/.bin:$PATH:/media/user/bin:/media/user/Library/android-sdk-linux/tools:/media/user/Library/android-sdk-linux/platform-tools
# }}}

# Untracked Mods
source ~/.zshrc_local
