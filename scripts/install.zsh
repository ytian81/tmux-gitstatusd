#!/usr/bin/env zsh

CURRENT_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
source "$CURRENT_DIR/variables.zsh"

[[ -f $settings[bin] ]] && 'return'

# gitstatusd binary doesn't exist
# clone repo and install gitstatusd binrary
local dir=$(mktemp -d)
git clone -q --depth 1 https://github.com/romkatv/gitstatus.git "$dir/gitstatusd"
source "$dir/gitstatusd/install"
