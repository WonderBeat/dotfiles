if status is-interactive
    set -U __done_min_cmd_duration 9000
    set -U __done_exclude 'git (?!push|pull)'
    set -U __done_notify_sound 1
    set -U __done_notification_urgency_level low


    function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
    end
    functions --copy fish_prompt vterm_old_fish_prompt
    function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
        # Remove the trailing newline from the original prompt. This is done
        # using the string builtin from fish, but to make sure any escape codes
        # are correctly interpreted, use %b for printf.
        printf "%b" (string join "\n" (vterm_old_fish_prompt))
        vterm_prompt_end
    end


    function vterm_cmd --description 'Run an Emacs command among the ones been defined in vterm-eval-cmds.'
        set -l vterm_elisp ()
        for arg in $argv
            set -a vterm_elisp (printf '"%s" ' (string replace -a -r '([\\\\"])' '\\\\\\\\$1' $arg))
        end
        vterm_printf '51;E'(string join '' $vterm_elisp)
    end


    if [ "$INSIDE_EMACS" = 'vterm' ]
        function clear
            vterm_printf "51;Evterm-clear-scrollback";
            tput clear;
        end
    end

    function fish_title
        hostname
        echo ":"
        pwd
    end

    direnv hook fish | source
end
