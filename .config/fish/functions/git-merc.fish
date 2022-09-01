function git-merc
    set -l options (fish_opt -s h -l help)
    set options $options (fish_opt -s b -l branch --optional-val)
    set options $options (fish_opt -s t -l target --optional-val)
    argparse $options -- $argv or return

    set -q _flag_branch; or set _flag_branch (git symbolic-ref --short HEAD)
    set -q _flag_target; or set _flag_target $GIT_MERGE_DEFAULT_BRANCH

    if set -q _flag_help
        echo echo "Specify branch to merge with -b (default $_flag_branch) and target branch with -t (default $_flag_target)."
        return 0
    end

    echo "Merging $_flag_branch into $_flag_target with merge commit"
    read

    git co $_flag_target
    git merc $_flag_branch
    git br -d $_flag_branch
end
