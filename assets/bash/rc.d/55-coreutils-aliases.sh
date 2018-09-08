# enable color support of ls and also add handy aliases
if nidus_has dircolors; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# one-letter shortcuts
alias -- -='cd ..'
alias g='grep -Ein'
alias j='jobs -l'
alias l='ls -hltr'
alias p='ps -ef'

# graphical open shortcut
if [ `uname` == Linux ]; then
    alias o='xdg-open'
elif [ `uname` == Darwin ]; then
    alias o='open'
elif [ `uname` == FreeBSD ]; then
    alias o='xdg-open'
    alias ls='ls -G'
fi

# auto parameters
alias rm='rm -vi'
alias cp='cp -vi'
alias mv='mv -vi'
nidus_has vim && alias vi='vim'

