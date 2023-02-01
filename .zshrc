case `uname` in
  Darwin)
    if [ "$TERM_PROGRAM" = "iTerm.app" ]
    then
        images=()
        while IFS=  read -r -d $'\0'; do
            images+=("$REPLY")
        done < <(find ~/Dropbox/Pokemon-Terminal/pokemonterminal/Images/ -name "*.jpg" -print0)
        num_images=${#images[*]}
        myfilename="`echo ${images[$((RANDOM%$num_images + 1))]}`"
        rand_img="/tmp/wppr$(($RANDOM%10)).jpg"
        rm -f "$rand_img" &> /dev/null
        ln -s "$myfilename" "$rand_img"
        base64filename=`echo "$rand_img"| base64`;
        echo "\033]1337;SetBackgroundImageFile=${base64filename}\a";
    fi
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

if command -v fzf-share >/dev/null; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

export ZPLUG_HOME=${ZPLUG_HOME:-"$HOME/.zplug"}
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

#config clone --bare https://github.com/WonderBeat/dotfiles.git ~/.myconf
# git@github.com:WonderBeat/dotfiles.git
#config checkout
alias config="$(which git) --git-dir=$HOME/.myconf/ --work-tree=$HOME"
alias mvn=mvn -T4
alias python=python3
alias vim='nvim'
alias make='make -s --no-print-directory'
alias wakeup='ssh router ether-wake -i br0 -b 00:11:32:CA:FE:69'
alias nix-shell="nix-shell --command zsh"
alias update="sudo nixos-rebuild switch"
alias update-home="home-manager switch"
eval "$(direnv hook zsh)"


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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v jj &> /dev/null
then
    source <(jj debug completion --zsh | sed '$d')
fi


# An emacs 'alias' with the ability to read from stdin
function em
{
    # If the argument is - then write stdin to a tempfile and open the
    # tempfile.
    if [[ $# -ge 1 ]] && [[ "$1" == - ]]; then
        tempfile="$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)"
        cat - >! "$tempfile"
        emacsclient -n --eval "(find-file \"$tempfile\")" \
            --eval '(set-visited-file-name nil)' \
            --eval '(rename-buffer "*stdin*" t))'
    else
        emacsclient -n "$@"
    fi
}

