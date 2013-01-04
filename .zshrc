# Get colors.
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
  colors
fi

# Use colors and set up a fancy prompt.
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  PS1="%{$fg_bold[white]%}%(2L.+.)%(!.%{$fg[red]%}.%{$fg_no_bold[green]%})%n%{$fg[blue]%}@%m%{$fg_bold[yellow]%}:%j%{$fg[blue]%}%~%{$fg[green]%}]%{$reset_color%}"
  RPS1="%{$fg_bold[yellow]%}%(?..%? )%{$fg[grey]%}(%D{%H:%M})%{$reset_color%}"
  # add to LS_COLORS to make other archive formats consistent
  LS_COLORS="$LS_COLORS"'*.xz=01;31:*.txz=01;31:*.lrz=01;31:'
else
  PS1="%n@%m:%j%~]"
fi

# filer go write permissions from created files
umask 0022

# use pythonrc for tab completion in interactive mode
export PYTHONSTARTUP=~/.config/pythonrc
export EDITOR=$(which vim)
export BROWSER=$(which firefox)
export MANWIDTH=${MANWIDTH:-80}
# use the good monitor for fullscreen
#export SDL_VIDEO_FULLSCREEN_DISPLAY=0

# better tab completion for cd builtin
cdpath=(.. ~)

zmodload zsh/mathfunc
zmodload zsh/complist
autoload -U zmv
autoload -U compinit
compinit

# configure history and history options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
(( $(grep -vc ^: $HISTFILE) > .9 * HISTSIZE )) \
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
setopt REMATCH_PCRE
setopt NO_FLOW_CONTROL

# a couple aliases
alias -g L="| less"
alias -g N="&>/dev/null"
alias -g E="&|exit"
alias ll="ls -lah"
alias sudo="sudo "
alias pacman="sudo pacman"
alias systemctl="sudo systemctl"
#alias mplayer="mplayer -nolirc -heartbeat-cmd \"xscreensaver-command -deactivate >/dev/null\""
alias apg="apg -m8 -x10 -MSNCL -s -t"
alias zathura="zathura --fork -l error"
# radio stuff
# alias hardradio='mplayer -playlist http://www.hardradio.com/streaming/aac.m3u'
# alias planetrock='mplayer -playlist http://www.planetrock.com/planetrock.m3u'
# alias radio1='mplayer -playlist http://www.bbc.co.uk/radio/listen/live/r1_aaclca.pls'
# alias radio2='mplayer -playlist http://www.bbc.co.uk/radio/listen/live/r2_aaclca.pls'
# alias radiocity='mplayer -playlist http://tx.whatson.com/icecast.php?i=city.aac.m3u'
# alias r1='mplayer -playlist http://www.bbc.co.uk/radio1/wm_asx/aod/radio1.asx'

# source zkbd-generated associative array, key
. ~/.zkbd/$TERM-$VENDOR-$OSTYPE

# make some fancier zle widgets available
zmodload zsh/deltochar
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N incremental-complete-word
zle -N predict-on
zle -N predict-off
zle -N edit-command-line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U incremental-complete-word predict-on
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
zstyle ':completion:*' users-hosts  'j_pew@cs.smu.ca'
# rsync completion doesn't use users-hosts for some reason
zstyle ':completion:*:complete:rsync:*' users j_pew
zstyle ':completion:(match-word|most-recent-file):*' match-original both
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' completer _expand _complete _ignored #_approximate
#zstyle ':completion:*' max-errors 1
#zstyle ':completion:*:complete:snes9x:*' file-patterns '/homse/shared/games/snes/*.smc:roms' '%p:all-files'
# snes9x requires OSS emulation. use modprobe snd-pcm-oss snd-seq-oss

# keybindings (Emacs mode)
bindkey -e
[[ -n ${key[Home]} ]]    && bindkey "${key[Home]}"    beginning-of-line
[[ -n ${key[End]} ]]     && bindkey "${key[End]}"     end-of-line
[[ -n ${key[Up]} ]]      && bindkey "${key[Up]}"      up-line-or-beginning-search
[[ -n ${key[Down]} ]]    && bindkey "${key[Down]}"    down-line-or-beginning-search
[[ -n ${key[C_Right]} ]] && bindkey "${key[C_Right]}" forward-word
[[ -n ${key[C_Left]} ]]  && bindkey "${key[C_Left]}"  backward-word
bindkey "	" expand-or-complete-prefix
bindkey "q" push-line-or-edit
bindkey "" delete-to-char
bindkey "" zap-to-char
bindkey "" list-choices
bindkey "" kill-region
bindkey "i" incremental-complete-word
bindkey "p" predict-on
bindkey "" predict-off
bindkey "" edit-command-line
bindkey "h" _complete_help
bindkey "m" _most_recent_file
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# WORDCHARS influences forward-word, backward-kill-word, &c. It is convenient to remove some bits.
# Here, I remove the slash and add the backslash. This makes it easier to work with file paths.
WORDCHARS='*?_-.[]~=\&;!#$%^(){}<>'

# do not need this parameter lying around; it is easier to hit 
unset key

# keychain is even less hassle than ssh-agent; use it here in the alias style
[[ root != $USER ]] && alias ssh='eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa) && ssh'

# other stuff goes in here!
fpath+="$HOME/.Zsh"
autoload greph man nmount radio colortest D3
