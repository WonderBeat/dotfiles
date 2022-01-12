# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export GOPATH=$HOME/golang
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "b4b4r07/enhancd", use:init.sh
zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "djui/alias-tips"

if ! zplug check; then
   zplug install
fi
#zplug "changyuheng/fz", defer:1
zplug load
export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export VISUAL=vim
export EDITOR="$VISUAL"

[ -s "/Users/$USERNAME/.jabba/jabba.sh" ] && source "/Users/$USERNAME/.jabba/jabba.sh"

source /Users/$USERNAME/Library/Preferences/org.dystroy.broot/launcher/bash/br
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '


alias mvn=mvn -T4

alias paste=curl -d private=1 -d name=Sumshit --data-urlencode text@/dev/stdin https://paste.corp.mail.ru/api/create

alias cmdb='ssh srve2855 cmdb'
alias cqm='ssh srve2855 cmdb -m -A'
alias cqn='ssh srve2855 cmdb -msf1'
alias hdfs='ssh srve2855 hdfs'
alias vim='nvim'
alias cat='bat'
alias dpmeet="open 'zoommtg://mailru.zoom.us/join?action=join&confno=92369283334&pwd=TVlIOC9DRlZDcU5KYkR3SVFaWmk3QT09&confid=dXRpZD1VVElEX2UzYTZiOWMzMjk3OTQwODNiZjljY2'"

mcc() {
 source /Users/denis.golovachev/Documents/projects/one-cloud/venv/bin/activate
 /Users/denis.golovachev/Documents/projects/one-cloud/bin/mcc3 $@
}

s() {
 if [[ $1 == *.odkl.ru ]]
 then
  mcc ssh $@
 else
  ssh $@
 fi
}


#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
#[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
#[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
if [[ ${INSIDE_EMACS:-no_emacs_here} != 'no_emacs_here' ]]; then
    export EDITOR=emacsclient
    export VISUAL=emacsclient
    export PAGER=less

    alias magit="emacsclient -ne '(magit-status)'"

    function man() { emacsclient -ne "(man \"$1\")"; }
fi

# vterm function required to integrate zsh and vterm-emacs
vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi
