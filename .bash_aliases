alias iterm_off="/usr/libexec/PlistBuddy -c 'Add :LSUIElement bool true' /opt/homebrew-cask/Caskroom/iterm2/3.0.4/iTerm.app/Contents/Info.plist"
alias ghc-sandbox="ghc -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghci-sandbox="ghci -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias runhaskell-sandbox="runhaskell -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias fuck='$(thefuck $(fc -ln -1))'
alias git-clean-outdated='$(git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d)'