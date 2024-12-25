
USERNAME=$(whoami)

if [ "$USERNAME" = "coder" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    eval "$(devbox global shellenv)"
fi

if [[ -s "$HOME/.config/broot/launcher/bash/br" ]]; then
  source "$HOME/.config/broot/launcher/bash/br"
  # test -e  "${HOME}/Library/Application Support/org.dystroy.broot/launcher/bash/br" && source "${HOME}/Library/Application Support/org.dystroy.broot/launcher/bash/br"
fi

source ~/.bash_aliases

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

export VISUAL=nvim
export EDITOR="$VISUAL"
export ZPLUG_HOME=${ZPLUG_HOME:-"$HOME/.zplug"}
export AUTO_NOTIFY_THRESHOLD=60
export AUTO_NOTIFY_IGNORE=("docker" "man" "sleep" "emacs" "java" "k9s" "kubectl" "brew")
export ENHANCD_FILTER="fzf --preview 'exa -al --tree --level 1 --group-directories-first --git-ignore --header --git --no-user --no-time --no-filesize --no-permissions {}' --preview-window right,50% --height 35% --reverse --ansi:fzy:peco"

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi


# encrypt using ssh key
sage() {
 age -a -R ~/.ssh/id_ed25519.pub <<< "$1"
}
# age decrypt using ssh key
saged() {
 age -d -i ~/.ssh/id_ed25519 <<< "$1"
}

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

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

source $ZPLUG_HOME/init.zsh
zplug "b4b4r07/enhancd", use:init.sh
zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "djui/alias-tips"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug romkatv/powerlevel10k, as:theme, depth:1
# zplug "MichaelAquilina/zsh-auto-notify", defer:3
zplug load
# export PATH="$HOME/.fastlane/bin:$PATH"

#config clone --bare https://github.com/WonderBeat/dotfiles.git ~/.myconf
# git@github.com:WonderBeat/dotfiles.git
#config checkout

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


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# if command -v jj &> /dev/null
# then
#     source <(jj debug completion --zsh | sed '$d')
# fi

if command -v carapace &> /dev/null
then
    zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
    source <(carapace _carapace)
fi

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

eval "$(direnv hook zsh)"
