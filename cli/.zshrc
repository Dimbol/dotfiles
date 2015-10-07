# ~/.zshrc

# Let's run user processes with more niceness.
#(( $SHLVL < 3 )) && renice +5 -p $$ &>/dev/null

# Get colors and set up a fancy prompt.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
  alias grep='grep --color=auto'
  alias ls='ls -G'
  PS1="%{$fg_bold[white]%}%(2L.+.)%(!.%{$fg[red]%}.%{$fg_no_bold[green]%})%n%{$fg[blue]%}@%m%{$fg_bold[yellow]%}:%j%{$fg[blue]%}%~%{$fg[green]%}]%{$reset_color%}"
  RPS1="%(?..%{$fg_bold[yellow]%}%?%{$reset_color%})"
else
  PS1="%n@%m:%j%~]"
fi

# It's time to learn tmux!
if pgrep tmux &>/dev/null; then
  ntmux=$(( $(tmux list-sessions | wc -l) ))
  [[ -z $TMUX ]] && print "$fg_no_bold[yellow]TMUX sessions available: $fg_bold[yellow]$ntmux$reset_color"
  unset ntmux
else
  tmux
fi

# default permissions
umask 0022

# general environment variables
export EDITOR="vim"
##export VISUAL="$(which gvim) -f"
export BROWSER="firefox"
export MANWIDTH=${MANWIDTH:-80}
export PAGER="less"

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
alias -g L="| $PAGER"
alias -g N="&>/dev/null"
alias -g E="&|exit"

alias ll="ls -lah"
alias tailf="tail -f"
alias sudo="sudo "
#alias mplayer="mplayer -af scaletempo"  # speed up playback w/o audio distortion
#alias zathura="zathura --fork -l error"
alias benice="renice -n 19 -p $$ && ionice -c3 -p $$ && ionice -p $$"

# make some fancier zle widgets available
zmodload zsh/deltochar
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N incremental-complete-word
#zle -N predict-on
#zle -N predict-off
zle -N edit-command-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U incremental-complete-word
#autoload -U predict-on
autoload -U edit-command-line

# styles for completion system and stuff
zstyle ':completion:*:descriptions' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=4
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':compinstall' filename '~/.zshrc'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #(<->)*=0=01;31'
zstyle ':completion:(match-word|most-recent-file):*' match-original both
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored #_approximate
#zstyle ':completion:*' max-errors 1

# source zkbd-generated associative array, key
#. ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}

# keybindings (Emacs mode)
bindkey -e
bindkey "[1~" beginning-of-line
bindkey "[4~" end-of-line
bindkey "[A" up-line-or-beginning-search
bindkey "[B" down-line-or-beginning-search
bindkey "^K" up-line-or-beginning-search
bindkey "^J" down-line-or-beginning-search
bindkey "	" expand-or-complete-prefix
bindkey "q" push-line-or-edit
bindkey "" delete-to-char
bindkey "" zap-to-char
bindkey "" list-choices
#bindkey "" kill-region
bindkey "i" incremental-complete-word
#bindkey "p" predict-on
#bindkey "" predict-off
bindkey "" edit-command-line
bindkey "h" _complete_help
bindkey "m" _most_recent_file

# do not need this parameter lying around; it is easier to hit 
#unset key

# WORDCHARS influences forward-word, backward-kill-word, &c. It is convenient to remove some bits.
# Here, I remove the slash and add the backslash. This makes it easier to work with file paths.
WORDCHARS='*?_-.[]~=\&;!#$%^(){}<>'

# keychain is even less hassle than ssh-agent
#[[ root != $USER ]] && {
#  pgrep ssh-agent &>/dev/null || {
#    keychain --agents ssh --nogui -Q -q ~/.ssh/id_school
#  }
#  [[ -f ~/.keychain/$HOST-sh ]] && . ~/.keychain/$HOST-sh
#}

# other stuff goes in here!
fpath+=~/.zsh
autoload greph man

# source the zsh-syntax-highlighting plugin
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_STYLES[globbing]='underline'
