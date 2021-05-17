#!/usr/bin/env zsh

# set -euo pipefail
# 
# set -x
# echo "start at: $(date)" >&2
# exec 2> /tmp/install_debug.log

CURRENT_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
source "$CURRENT_DIR/variables.zsh"

[[ -f $settings[bin] ]] && 'return'

# gitstatusd binary doesn't exist
# clone repo and install gitstatusd binrary
# TODO: this is not the best way to download binary
local dir=$(mktemp -d)
git clone -q https://github.com/romkatv/gitstatus.git "$dir/gitstatusd"
source "$dir/gitstatusd/install"
