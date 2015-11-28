# ~/.zshrc

# It's time to learn tmux!  Launch it immediately if no sessions currently exist.
# The bulk of this .zshrc is short-circuited while tmux runs.
if ! pgrep tmux &>/dev/null; then
  command -v tmux &>/dev/null && tmux
  exit
fi

# Get colors and set up a fancy prompt.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
  export GREP_OPTIONS='--color=auto'  # used by the grep family
  export CLICOLOR='1'                 # used by ls

  PS1="%{$fg_bold[white]%}%(2L.+.)%(!.%{$fg[red]%}.%{$fg_no_bold[green]%})%n%{$fg[blue]%}@%m%{$fg_bold[yellow]%}:%j%{$fg[blue]%}%~%{$fg[green]%}]%{$reset_color%}"

  # When vicmd mode is active in the line editor, an indicator is nice to have.
  # Process error codes are reported in RPS1 as well.
  RPS1="%(?..%{$fg_bold[yellow]%}%?%{$reset_color%})"
  function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/[VICMD]}/(main|viins)/}%(?..[%{$fg_bold[yellow]%}%?%{$reset_color%}])"
    zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
else # a boring fallback prompt
  PS1="%n@%m:%j%~]"
fi

# It's time to learn tmux!  If there are existing sessions, just notify the user.
if pgrep tmux &>/dev/null; then
  ntmux=$(( $(tmux list-sessions | wc -l) ))
  [[ -z $TMUX ]] && print "$fg_no_bold[yellow]TMUX sessions available: $fg_bold[yellow]$ntmux$reset_color"
  unset ntmux
fi

# default permissions
umask 0022

# general environment variables
export EDITOR="vim"
#export VISUAL="$(which gvim) -f"
#export BROWSER="firefox"
export MANWIDTH=${MANWIDTH:-80}
export PAGER="less"
export LESSHISTFILE="-"

zmodload zsh/mathfunc
zmodload zsh/complist
autoload -U zmv
autoload -U compinit
compinit

# configure history and history options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
[[ -r $HISTFILE ]] \
  && (( $(grep -vc ^: $HISTFILE) > .97 * HISTSIZE )) \
  && print "$fg[red] Notice: $HISTFILE is nearly full.$reset_color"
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt INTERACTIVE_COMMENTS

# set some other options
setopt NO_BEEP
setopt CSH_NULL_GLOB
setopt EXTENDED_GLOB
setopt BRACE_CCL
setopt EQUALS
setopt CORRECT
setopt HASH_LIST_ALL
setopt NO_NOMATCH
setopt COMPLETE_IN_WORD
setopt NO_FLOW_CONTROL

# a couple aliases
#alias -g L="| $PAGER"
#alias -g N="&>/dev/null"
#alias -g E="&|exit"

alias ll="ls -lah"
alias tailf="tail -F"
alias sudo="sudo "
alias view="vim -R"

# styles for completion system and stuff
zstyle ':compinstall' filename '~/.zshrc'
zstyle ':completion:*:descriptions' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=4
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #(<->)*=0=01;31'
zstyle ':completion:(match-word|most-recent-file):*' match-original both
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:}'  # allows case-insensitive tab completion as a fallback
zstyle ':completion:*' completer _expand _complete _ignored

# make some fancier zle widgets available
zmodload zsh/deltochar
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U edit-command-line

# customize delete-to-char to reverse its direction
function backward-delete-to-char() {
  zle delete-to-char -n $(( -1 * ${NUMERIC:-1} ))
}
zle -N backward-delete-to-char

# prefix the command with a space to better use setopt HIST_IGNORE_SPACE
function toggle-prefix-with-space() {
  (( ${#BUFFER} == 0 )) && return
  if [[ ${BUFFER[1]} != ' ' ]]; then
    LBUFFER=" ${LBUFFER}"
  else
    if (( ${#LBUFFER} > 0 )); then
      LBUFFER="${LBUFFER[2,-1]}"
    else
      BUFFER="${BUFFER[2,-1]}"
    fi
  fi
}
zle -N toggle-prefix-with-space

# assume low latency so that the timeout for prefix keys can be short
# this particularly affects the "^[" keybinding
KEYTIMEOUT=5  # 50ms

# keybindings (Emacs mode)
bindkey -e
bindkey "^[" vi-cmd-mode  # temporary vi mode when desired
bindkey -a "^[" vi-insert
bindkey "^[ " toggle-prefix-with-space
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^K" up-line-or-beginning-search
bindkey "^J" down-line-or-beginning-search
bindkey "^[^[[C" forward-word   # conflicts with i3 wm settings
bindkey "^[^[[D" backward-word  # conflicts with i3 wm settings
bindkey "^I" expand-or-complete-prefix
bindkey "^[q" push-line-or-edit
bindkey "^X^D" delete-to-char
bindkey "^X^Z" backward-delete-to-char
bindkey "^D" list-choices
bindkey "^X^E" edit-command-line
bindkey "^Xh" _complete_help
bindkey "^Xm" _most_recent_file
bindkey -r "^[h" "^[H"  # run-help is annoying

# WORDCHARS influences forward-word, backward-kill-word, &c. It is convenient to remove some bits.
# Here, I remove the slash and add quotes. This makes it easier to work with file paths.
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>"'\'

# keychain is even less hassle than ssh-agent
(( $UID )) && {
#  pgrep ssh-agent &>/dev/null || {
#    keychain --agents ssh --nogui --quick --quiet ~/.ssh/id_rsa
#  }
  [[ -f ~/.keychain/$HOST-sh ]] && source ~/.keychain/$HOST-sh
}

# other zsh stuff goes in here!
fpath=(~/.zsh ~/.zsh/completion $fpath)
autoload greph man

# some programs may be installed in ~/.local/bin
[[ -d ~/.local/bin ]] && path+=~/.local/bin

# source the zsh-syntax-highlighting plugin
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[globbing]='underline'
