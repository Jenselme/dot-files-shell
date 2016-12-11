set -e
set -u


function main {
    local repo_root=~/Work

    for possible_git_dir in ${repo_root}/*; do
        if [[ -d "${possible_git_dir}" && -d "${possible_git_dir}/.git" ]]; then
            echo "${possible_git_dir}"
            cd "${possible_git_dir}"
            git push -q --no-verify
        fi
    done
}


main

