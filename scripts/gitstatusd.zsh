#!/usr/bin/env zsh

set -euo pipefail

# set -x
# echo "start at: $(date)" >&2
# exec 2> /tmp/tmux-git-status.log

CURRENT_DIR="$( cd "$( dirname "${(%):-%N}" )" && pwd )"
source "$CURRENT_DIR/variables.zsh"

function main {
    [[ ! -f $settings[bin] ]] && { echo "Please install gitstatusd first" && exit 1; }

    local req_id=tmux-gitstatusd
    local dir=$(tmux display-message -p -F "#{pane_current_path}")

    echo -nE $req_id$'\x1f'$dir$'\x1e' | $settings[bin] -s -1 -u -1 -c -1 -d -1 -v FATAL| {
        local resp
            IFS=$'\x1f' read -rd $'\x1e' -A resp

            if (( resp[2] )); then
                for VCS_STATUS_WORKDIR              \
                    VCS_STATUS_COMMIT               \
                    VCS_STATUS_LOCAL_BRANCH         \
                    VCS_STATUS_REMOTE_BRANCH        \
                    VCS_STATUS_REMOTE_NAME          \
                    VCS_STATUS_REMOTE_URL           \
                    VCS_STATUS_ACTION               \
                    VCS_STATUS_INDEX_SIZE           \
                    VCS_STATUS_NUM_STAGED           \
                    VCS_STATUS_NUM_UNSTAGED         \
                    VCS_STATUS_NUM_CONFLICTED       \
                    VCS_STATUS_NUM_UNTRACKED        \
                    VCS_STATUS_COMMITS_AHEAD        \
                    VCS_STATUS_COMMITS_BEHIND       \
                    VCS_STATUS_STASHES              \
                    VCS_STATUS_TAG                  \
                    VCS_STATUS_NUM_UNSTAGED_DELETED \
                    VCS_STATUS_NUM_STAGED_NEW       \
                    VCS_STATUS_NUM_STAGED_DELETED   \
                    VCS_STATUS_PUSH_REMOTE_NAME     \
                    VCS_STATUS_PUSH_REMOTE_URL      \
                    VCS_STATUS_PUSH_COMMITS_AHEAD   \
                    VCS_STATUS_PUSH_COMMITS_BEHIND  \
                    VCS_STATUS_NUM_SKIP_WORKTREE    \
                    VCS_STATUS_NUM_ASSUME_UNCHANGED in "${(@)resp[3,27]}"; do
                done
                VCS_STATUS_HAS_UNSTAGED=$((VCS_STATUS_NUM_UNSTAGED > 0))
                VCS_STATUS_HAS_CONFLICTED=$((VCS_STATUS_NUM_CONFLICTED > 0))
                VCS_STATUS_HAS_UNTRACKED=$((VCS_STATUS_NUM_UNTRACKED > 0))
                VCS_STATUS_HAS_STAGED=$((VCS_STATUS_NUM_STAGED > 0))

                local tmux_git_status

                tmux_git_status="${settings[prefix]}"

                if [[ -n "${settings[icon]}" ]]; then
                    tmux_git_status+="${settings[icon]} "
                fi
                tmux_git_status+="${${VCS_STATUS_LOCAL_BRANCH:-@${VCS_STATUS_COMMIT}}//\%/%%}"

                if [[ $VCS_STATUS_COMMITS_AHEAD != "0" ]]; then
                    tmux_git_status+=" ${settings[icon-ahead]}"
                    [[ "${settings[ahead-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_COMMITS_AHEAD"
                fi

                if [[ $VCS_STATUS_COMMITS_BEHIND != "0" ]]; then
                    tmux_git_status+=" ${settings[icon-behind]}"
                    [[ "${settings[behind-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_COMMITS_BEHIND"
                fi

                if [[ $VCS_STATUS_HAS_STAGED == 1 ]]; then
                    tmux_git_status+=" ${settings[icon-staged]}"
                    [[ "${settings[staged-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_NUM_STAGED"
                fi

                if [[ $VCS_STATUS_HAS_UNSTAGED == 1 ]]; then
                    tmux_git_status+=" ${settings[icon-unstaged]}"
                    [[ "${settings[unstaged-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_NUM_UNSTAGED"
                fi

                if [[ $VCS_STATUS_HAS_UNTRACKED == 1 ]]; then
                    tmux_git_status+=" ${settings[icon-untracked]}"
                    [[ "${settings[untracked-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_NUM_UNTRACKED"
                fi

                if [[ $VCS_STATUS_STASHES != "0" ]]; then
                    tmux_git_status+=" ${settings[icon-stashes]}"
                    [[ "${settings[stashes-count]}" == 'true' ]] && tmux_git_status+="$VCS_STATUS_STASHES"
                fi
                tmux_git_status+="${settings[suffix]}"

                printf "%s" "${tmux_git_status}"

            fi
        }
}

main
