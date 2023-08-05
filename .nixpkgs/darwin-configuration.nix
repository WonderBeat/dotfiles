{ config, pkgs, stdenv, ... }:

let
  inherit (pkgs) lorri;
  unstable = import <unstable> {};
  # unison-ucm = import (fetchTarball "https://github.com/ceedubs/unison-nix/archive/trunk.tar.gz") {};
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium sansmathfonts sansmath
      fontspec
      wrapfig amsmath ulem hyperref capt-of
      collection-pstricks
      collection-fontsrecommended
      beamer
      sourcecodepro
      l3packages
      mathastext
      pgf
      cancel
      cprotect
      bigfoot
      environ
      cbfonts-fd
      xcolor;
  });
in {
  environment.systemPackages =
    [ lorri
      pkgs.gh
      pkgs.broot
      pkgs.s3cmd
      pkgs.fzf
      pkgs.watch
      pkgs.up
      pkgs.fd
      pkgs.mosh
      pkgs.ncdu
      pkgs.neovim
      pkgs.tree-sitter
      pkgs.ripgrep
      pkgs.age
      pkgs.git
      pkgs.gnupg
      pkgs.yaml-language-server
      pkgs.nixFlakes
      pkgs.direnv 
      pkgs.rustup
      pkgs.glances
      pkgs.pipenv
      pkgs.shellcheck
      pkgs.mu
      pkgs.pandoc
      pkgs.rsync
      pkgs.shfmt
      pkgs.hunspell
      pkgs.aria2
      pkgs.git-crypt
      pkgs.git-lfs
      pkgs.rclone
      pkgs.syncthing
      tex
      unstable.micromamba
      unstable.devbox
      unstable.nmap
      unstable.jujutsu
      unstable.git-branchless
      unstable.stgit
      unstable.earthly
      unstable.k9s
      ];

  fonts.fontDir.enable = true;

  nix.extraOptions = ''
    auto-optimise-store = true
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  security.pam.enableSudoTouchIdAuth = true;
  programs.nix-index.enable = true;

  fonts.fonts = with pkgs; [
    proggyfonts
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "SourceCodePro" "Monoid" "FiraCode" "DroidSansMono" "Meslo" "Overpass" "BigBlueTerminal" "Iosevka" "Gohu" ]; })
  ];

  environment.variables = rec {
     RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  #programs.zsh.zplug.enable = true;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  nix.package = pkgs.nix;
  launchd.user.agents = {
    # "lorri" = {
    #   serviceConfig = {
    #     WorkingDirectory = (builtins.getEnv "HOME");
    #     EnvironmentVariables = { };
    #     KeepAlive = true;
    #     RunAtLoad = true;
    #     StandardOutPath = "/var/tmp/lorri.log";
    #     StandardErrorPath = "/var/tmp/lorri.log";
    #   };
    #   script = ''
    #     source ${config.system.build.setEnvironment}
    #     exec ${lorri}/bin/lorri daemon
    #   '';
    # };
    "warpd" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/warpd.log";
        StandardErrorPath = "/var/tmp/warpd.log";
        ProgramArguments = [ "/Users/$USER/.bin/warpd" "-f" ];
        ProcessType = "Interactive";
      };
      # command =  -f";
      # script = ''
      #   source ${config.system.build.setEnvironment}
      # '';
    };
  };

  homebrew = {
  enable = true;
  onActivation.upgrade = true;
  # updates homebrew packages on activation,
  # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
  taps = [
    "d12frosted/emacs-plus"
    "uptech/homebrew-oss"
  ];
  brews = [
    {
      name = "emacs-plus@29";
      args = ["with-modern-doom3-icon"];
    }
    "git-ps-rs"
    "mermaid-cli"
    "spoof-mac"
    "wireguard-go"
    "wireguard-tools"
    "lima"
    # {
    #   name = "koekeishiya/formulae/yabai";
    #   start_service = true;
    # }
    # {
    #   name = "koekeishiya/formulae/skhd";
    #   start_service = true;
    # }
  ];
  casks = [
    "telegram"
    "discord"
    "iterm2"
    "little-snitch"
    "macfuse"
    "gimp"
    "mat"
    "steam"
    "vlc"
    "fuse"
    "tor-browser"
    "xnviewmp"
    "trezor-suite"
    "firefox"
    "cool-retro-term"
    "gimp"
    "veracrypt"
    # "virtualbox"
    "plex"
    "jetbrains-toolbox"
    "visual-studio-code"
    "cyberduck"
    "amethyst"
    "hyper"
    "owasp-zap"
    "wireshark"
    # "soundflower"
    "openmtp"
    "imhex"
    "rectangle"
    "warp"
  ];
  };

}

