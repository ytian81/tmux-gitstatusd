#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
gitstatusd="#($CURRENT_DIR/scripts/gitstatusd.zsh)"
placeholder="\#{gitstatusd}"

source $CURRENT_DIR/scripts/shared.zsh
source $CURRENT_DIR/scripts/install.zsh

do_interpolation() {
    local string="$1"
    local interpolated="${string/$placeholder/$gitstatusd}"
    echo "$interpolated"
}

update_tmux_option() {
    local option="$1"
    local option_value="$(get_tmux_option "$option")"
    local new_option_value="$(do_interpolation "$option_value")"
    set_tmux_option "$option" "$new_option_value"
}

main() {
    update_tmux_option "status-left"
    update_tmux_option "status-right"
}

main
