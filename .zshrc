change() {
    images=()
    while IFS=  read -r -d $'\0'; do
        images+=("$REPLY")
    done < <(fd ".*.jpg" ~/Dropbox/Pokemon-Terminal/pokemonterminal/Images/ --print0)
    num_images=${#images[*]}
    myfilename="`echo ${images[$((RANDOM%$num_images + 1))]}`"
    rand_img="/tmp/wppr$(($RANDOM%10)).jpg"
    rm -f "$rand_img" &> /dev/null
    ln -s "$myfilename" "$rand_img"
    base64filename=`echo "$rand_img"| base64`;
    echo "\033]1337;SetBackgroundImageFile=${base64filename}\a";
    unset $RANDOM
}


case `uname` in
  Darwin)
    change
  ;;
  Linux)
    # commands for Linux go here
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
test -e "${HOME}/.linuxbrew/bin/brew" && eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
BREW_PREFIX="$(brew --prefix)"
export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"

export GOPATH=$HOME/golang
export GOROOT=$BREW_PREFIX/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/.bin

export ZPLUG_HOME=$BREW_PREFIX/opt/zplug
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
export PATH="$BREW_PREFIX/opt/qt/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"
export VISUAL=vim
export EDITOR="$VISUAL"

[ -s "/Users/$USERNAME/.jabba/jabba.sh" ] && source "/Users/$USERNAME/.jabba/jabba.sh"

[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '

# encrypt using ssh key
sage() {
 age -a -R ~/.ssh/id_ed25519.pub <<< "$1"
}
# age decrypt using ssh key
saged() {
 age -d -i ~/.ssh/id_ed25519 <<< "$1"
}

alias mvn=mvn -T4

alias python=python3
alias vim='nvim'
alias make='make -s --no-print-directory'

#config clone --bare git@github.com:WonderBeat/dotfiles.git ~/.myconf
#config checkout
alias config="$(which git) --git-dir=$HOME/.myconf/ --work-tree=$HOME"

#Daily team zoom Meeting
dpmeet() {
 local LINK=$(cat <<-EOF
		-----BEGIN AGE ENCRYPTED FILE-----
		YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IHNzaC1lZDI1NTE5IFZ1YW4yZyBsZTlS
		YTVSdVI0alhZQjRtb2oza1NuUFJFQ3FhcjY1VWwwRHJQa2NrQjA0CnZrSkYybldN
		ZnVsUFFPTlZwTTZzdWsxS3NNVCsrT3ZjYXVqYkVKZjk0N1UKLS0tIHpLSExiQmRU
		YUNxL2pxdEtEL3Njd0dXU21uS1lHNTdqeS9MZmE3aUFJd0EKg6bmLgtpyVJY/xa9
		Uun2zMCugYZC4fhHuwyS7cSjFiHdBfCyOtzE/L0X70uI4+n1ON6G2ROw7eW09Rr0
		d7lXwRolO6GDNaejy9g7Y+RAVI3dGqGKHfv6WPFYLfnYJ8cn1KzXda7G5fBEsEeL
		TeZ9Yee9klZSZxKsK/o9w/TvCMwtg0FqMXmZ1q/RMlJEXyW5dtAaDSz/cv7jNc6X
		LYYdPvwWgIkwmXO0jjuBu8S4OVsdpGj3
		-----END AGE ENCRYPTED FILE-----
EOF
 )
 open $(saged "$LINK")
}

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

#vterm directory tracking
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

#vterm command passing
vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

if [[ -s "/Users/$HOME/.config/broot/launcher/bash/br" ]]; then
  source "/Users/$HOME/.config/broot/launcher/bash/br"
fi

test -e  "${HOME}/Library/Application Support/org.dystroy.broot/launcher/bash/br" && source "${HOME}/Library/Application Support/org.dystroy.broot/launcher/bash/br"
export PATH="/usr/local/opt/python@3.10/bin:$PATH"
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"
export PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"

eval "$(thefuck --alias)"
eval "$(direnv hook zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source <(jj debug completion --zsh | sed '$d')
