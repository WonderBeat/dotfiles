
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
if [[ "$TERM_PROGRAM" = 'zed' ]]; then
    export VISUAL=zed
fi

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

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

case "$(uname)" in
    Darwin)
        if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
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
    Linux|FreeBSD)
        # Add platform-specific configurations here
        ;;
esac



test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZPLUG_HOME/init.zsh

zplug "b4b4r07/enhancd", use:init.sh
zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "djui/alias-tips"
zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug load
# export PATH="$HOME/.fastlane/bin:$PATH"

#config clone --bare https://github.com/WonderBeat/dotfiles.git ~/.myconf
# git@github.com:WonderBeat/dotfiles.git
#config checkout
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

aicm() {
  # Function to generate commit message from staged changes
  generate_commit_message() {
    git diff --cached | aichat "
Below is a diff of all staged changes, coming from the command:

\`\`\`
git diff --cached
\`\`\`

Please generate a concise commit message for these changes.
First line is title, summary. keep it short. no more than 100 symbols.
Second line is empty. Keep one empty line between title and description. It's important
Third line is description, more detailed. no more than 400 symbols.
Respond only with the commit message, without any additional commentary or formatting.
Respond in English.
Respond in markdown format but first line is not markdown. first line is just text
You can use emojis in the commit message.
You must not change the meaning of the changes.
Use imperative mood in the subject line.
Use markdown bullet list in the description if you have more than one change.
Use the body to explain what and why vs. how.
If there are no changes, respond with 'No changes to commit
Put appropriate emoji at the end of the title at the first line
'.
"
  }

  # Function to read user input compatibly with both Bash and Zsh
  read_input() {
    if [ -n "$ZSH_VERSION" ]; then
      echo -n "$1"
      read -r REPLY
    else
      read -p "$1" -r REPLY
    fi
  }

  # Main script
  echo "Generating..."
  commit_message=$(generate_commit_message)

  while true; do
    echo -e "\nProposed commit message:"
    echo "$commit_message"

    read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, or (c)ancel? "
    choice=$REPLY

    case "$choice" in
    a | A)
      if git commit -m "$commit_message"; then
        echo "Changes committed successfully!"
        return 0
      else
        echo "Commit failed. Please check your changes and try again."
        return 1
      fi
      ;;
    e | E)
      # Create a temporary file and pre-fill with the AI message
      local tmpfile
      tmpfile="$(mktemp "${TMPDIR:-/tmp}/aicm.XXXXXXX")"

      # Write the message exactly as generated
      printf '%s\n' "$commit_message" >! "$tmpfile"

      # Use Git's editor precedence: GIT_EDITOR → VISUAL → EDITOR → vim
      local editor
      if [[ "$TERM_PROGRAM" = 'zed' ]]; then
          editor=zed
      else
          editor=$(git var GIT_EDITOR 2>/dev/null) || editor=${VISUAL:-${EDITOR:-vim}}
      fi


      # Open editor
      if "$editor" "$tmpfile"; then
        # Read the edited content
        edited_message=$(cat "$tmpfile")

        # Check if message is non-empty (after trimming whitespace)
        if [ -n "$(printf '%s' "$edited_message" | tr -d ' \t\n\r')" ]; then
          if git commit -m "$edited_message"; then
            echo "Changes committed successfully with your edited message!"
            rm -f "$tmpfile"
            return 0
          else
            echo "Commit failed. Please check your changes and try again."
            rm -f "$tmpfile"
            return 1
          fi
        else
          echo "Edit cancelled: empty or whitespace-only message."
          rm -f "$tmpfile"
          # Return to menu loop
        fi
      else
        echo "Editor exited with error. Edit cancelled."
        rm -f "$tmpfile"
        # Return to menu loop
      fi
      ;;
    r | R)
      echo "Regenerating commit message..."
      commit_message=$(generate_commit_message)
      ;;
    c | C)
      echo "Commit cancelled."
      return 1
      ;;
    *)
      echo "Invalid choice. Please try again."
      ;;
    esac
  done
}

aicm-rewrite() {
  # Generate a new commit message based on the latest commit
  generate_new_commit_message() {
    local commit_hash
    commit_hash=$(git rev-parse --short HEAD 2>/dev/null) || {
      echo "Error: Not a git repository or no commits yet." >&2
      return 1
    }

    git show --no-color "$commit_hash" | aichat "
Below is the full content of the latest commit (hash: $commit_hash), from the command:

\`\`\`
git show --no-color $commit_hash
\`\`\`

Please generate a revised, improved commit message for this commit.
- First line: concise title in imperative mood (e.g., 'Fix bug in login flow'), ≤100 characters.
- Second line: empty (required).
- Third+ lines: detailed description explaining *what* changed and *why*, not *how*. ≤400 characters total.
- Use markdown bullet points if multiple distinct changes exist.
- You may use relevant emojis.
- Do NOT alter the factual meaning of the changes.
- Respond ONLY with the new commit message—no extra text, no quotes, no markdown code blocks.
- If the commit is empty or invalid, respond with 'No meaningful changes to rewrite'.
"
  }

  # Read user input compatibly with Bash/Zsh
  read_input() {
    if [ -n "$ZSH_VERSION" ]; then
      echo -n "$1"
      read -r REPLY
    else
      read -p "$1" -r REPLY
    fi
  }

  # Main logic
  echo "Analyzing latest commit and generating new message..."
  new_commit_message=$(generate_new_commit_message) || return 1

  while true; do
    echo -e "\nProposed new commit message:"
    echo "$new_commit_message"

    read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, or (c)ancel? "
    choice=$REPLY

    case "$choice" in
      a|A)
        if git commit --amend -m "$new_commit_message"; then
          echo "✅ Commit message updated successfully!"
          return 0
        else
          echo "❌ Amend failed. Please check your Git state."
          return 1
        fi
        ;;

      e|E)
        # Create temp file and pre-fill with the AI message
        local tmpfile
        tmpfile="$(mktemp "${TMPDIR:-/tmp}/aicm-rewrite.XXXXXXX")"

        # Write the message exactly as-is (preserving newlines, etc.)
        printf '%s\n' "$new_commit_message" >! "$tmpfile"

        # Honor Git's editor precedence
        local editor
        editor=$(git var GIT_EDITOR 2>/dev/null) || editor=${VISUAL:-${EDITOR:-vim}}

        # Launch editor
        if "$editor" "$tmpfile"; then
          # Read edited content
          edited_message=$(cat "$tmpfile")

          if [ -n "$(printf '%s' "$edited_message" | tr -d ' \t\n\r')" ]; then
            # Non-empty after trimming whitespace
            if git commit --amend -m "$edited_message"; then
              echo "✅ Commit message updated with your edits!"
              rm -f "$tmpfile"
              return 0
            else
              echo "❌ Failed to amend commit."
              rm -f "$tmpfile"
              return 1
            fi
          else
            echo "⚠️  Edit cancelled: empty or whitespace-only message."
            rm -f "$tmpfile"
            # Return to menu
          fi
        else
          echo "⚠️  Editor exited with error. Edit cancelled."
          rm -f "$tmpfile"
          # Return to menu
        fi
        ;;

      r|R)
        echo "🔄 Regenerating commit message..."
        new_commit_message=$(generate_new_commit_message) || return 1
        ;;

      c|C)
        echo "↩️  Rewrite cancelled."
        return 1
        ;;

      *)
        echo "❓ Invalid choice. Please try again."
        ;;
    esac
  done
}


alias sandbox-no-network='sandbox-exec -p "(version 1)(allow default)(deny network*)"'

eval "$(direnv hook zsh)"
