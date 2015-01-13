This repository contains most of my configuration files and my bin directory. It includes mostly:
- zsh
- git
- mercurial
- nano
- some scripts I find useful

My emacs configuration is in [a separate repo](https://github.com/Jenselme/dot-files-emacs).

# Shells
## Zsh
My configuration is based on [Oh My ZSH](http://ohmyz.sh/). I just changed the theme.

## All shells
- Some aliases in .aliases
- Useful functions in .functions:
  - ~extract~ to easily extract many kind of archives
  - ~man~ to add color to manpages

# git
My git configuration is really basic:
- Enables color
- Set nano as the default editor
- Defines some aliases for the most frequent git commands including:
  - Nice log graph capabilities
  - oups (add a file to the previous commit)

# mercurial
It just enables some extension I find useful (I am not a frequent user
of mercurial):
- Enables the progress extension to view a progress bar for each operation
- Enables the pager extension and configures it so less is used for commands like hg log
- Enables the color for the output
- Sets nano as the default editor

# nano
It just includes nanorc to have the proper coloration when editing a file.

# Bin scripts
- Backup scripts relying on rsync
- A script to delete all tables that match a pattern in MySQL
- A shell for pelican
- Scripts to create patch files based on a pattern (to remove it or replace it)
- And many commands that I tend to forget like (I guess I could convert them to
  functions instead):
  - ~take-pictures.sh~: ~fswebcam -d /dev/video1 -r 960x720 --png 0 --no-banner --no-timestamp --no-title --save $1~
  - ~compress-pdf.sh~: ~gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$1-out" "$1"~
