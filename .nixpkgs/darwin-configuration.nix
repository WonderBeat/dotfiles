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
      pkgs.watch
      pkgs.up
      pkgs.fd
      pkgs.mosh
      pkgs.zplug
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
      pkgs.binutils
      pkgs.aria2
      pkgs.git-crypt
      pkgs.git-lfs
      tex
      unstable.devbox
      unstable.nmap
      unstable.jujutsu
      unstable.git-branchless
      unstable.stgit
      unstable.earthly
      ];

  fonts.fontDir.enable = true;

  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  fonts.fonts = with pkgs; [
    proggyfonts
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "SourceCodePro" "Monoid" "FiraCode" "DroidSansMono" ]; })
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  nix.package = pkgs.nix;
  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${lorri}/bin/lorri daemon
      '';
    };
  };

  homebrew = {
  enable = true;
  onActivation.upgrade = true;
  # updates homebrew packages on activation,
  # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
  taps = [
    "d12frosted/emacs-plus"
  ];
  brews = [
    {
      name = "emacs-plus@29";
      args = ["with-modern-doom-icon"];
    }
    "mermaid-cli"
    "spoof-mac"
    "wireguard-go"
    "wireguard-tools"
    "koekeishiya/formulae/yabai"
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
    # "android-file-transfer"
    "fuse"
    "tor-browser"
    "xnviewmp"
    # "ghidra"
    "trezor-suite"
    "firefox"
    # "xpra"
    "cool-retro-term"
    "gimp"
    "veracrypt"
    "virtualbox"
  ];
  };

}

