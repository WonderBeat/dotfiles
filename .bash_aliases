alias iterm_off="/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /opt/homebrew-cask/Caskroom/iterm2/3.0.4/iTerm.app/Contents/Info.plist"
alias ghc-sandbox="ghc -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghci-sandbox="ghci -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias runhaskell-sandbox="runhaskell -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias fuck='$(thefuck $(fc -ln -1))'
alias git-clean-outdated='$(git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d)'
alias kp='(export KUBECONFIG=~/.kube/hetzner-prod.yaml && k9s)'
alias ks='(export KUBECONFIG=~/.kube/hetzner-stage.yaml && k9s)'
alias k9s="XDG_CONFIG_HOME=$HOME/.config/ k9s"
alias kubectl-list-all="kubectl api-resources --verbs=list -o name | xargs -n 1 kubectl get -o name"
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
