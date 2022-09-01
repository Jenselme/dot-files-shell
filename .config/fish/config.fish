fish_add_path /usr/local/bin
fish_add_path ~/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.nvm/versions/node/v(cat ~/.nvm/alias/default)/bin

set -gx WORKON_HOME ~/.virtualenvs

if status is-interactive
    starship init fish | source
    direnv hook fish | source
    load_nvm
    /usr/sbin/anacron -t ~/.config/anachron -S $HOME/.local/share/var/spool/anacron
end
