#!/usr/bin/env zsh

typeset -A settings
settings[icon]=''
settings[prefix]=' '
settings[suffix]=' '

settings[icon-staged]='+'
settings[icon-unstaged]='!'
settings[icon-untracked]='?'
settings[icon-stashes]='*'
settings[icon-ahead]='↑'
settings[icon-behind]='↓'

settings[staged-count]='true'
settings[unstaged-count]='true'
settings[untracked-count]='true'
settings[stashes-count]='true'
settings[ahead-count]='true'
settings[behind-count]='true'

settings[arch]=$(uname -m)
settings[os]=${${(L)$(command uname -s)}//ı/i}
settings[bin]="${GITSTATUS_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}}/gitstatus/gitstatusd-$settings[os]-$settings[arch]"
