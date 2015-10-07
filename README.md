This repository contains a few of the configurations I have in my home
directory, i.e., dotfiles.

The motivation behind this is to have a simple backup for some really
convenient settings, and to get an introduction to using github.

Since dotfiles may differ between machines, machines may have their own
branches (e.g., a branch for FreeBSD and a branch for Arch Linux).

GNU Stow is appropriate for creating symlinks to dotfiles within this
repository.  The packages stowed are:

* gui (containing i3 and X configs, with .Xresources color schemes coming
  from bbs.archlinux.org),
* vim (containing .vimrc and a submodule for the colorscheme kolor), and
* cli (containing .zshrc, a submodule for zsh-syntax-hightlighting,
  .tmux.conf, .login_conf, &c)
