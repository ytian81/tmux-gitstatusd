#!/usr/bin/env zsh

# set -euo pipefail

# set -x
# echo "start at: $(date)" >&2
# exec 2> /tmp/tmux-git-status.log

CURRENT_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
source "$CURRENT_DIR/variables.zsh"

install () {
    # gitstatusd binary exists
    [[ -f $settings[bin] ]] && return;

    # clone repo and install gitstatusd binrary
    local dir=$(mktemp -d)
    git clone -q https://github.com/romkatv/gitstatus.git "$dir/gitstatusd"
    source "$dir/gitstatusd/install"
}

install
