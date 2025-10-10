{ config, pkgs, stdenv, ... }:

let
  inherit (pkgs);
  unstable = import <unstable> { config.allowUnfree = true; };
  # unison-ucm = import (fetchTarball "https://github.com/ceedubs/unison-nix/archive/trunk.tar.gz") {};
  # tex = (pkgs.texlive.combine {
  #   inherit (pkgs.texlive) scheme-medium sansmathfonts sansmath
  #     fontspec
  #     wrapfig amsmath ulem hyperref capt-of
  #     collection-pstricks
  #     collection-fontsrecommended
  #     beamer
  #     sourcecodepro
  #     l3packages
  #     mathastext
  #     pgf
  #     cancel
  #     cprotect
  #     bigfoot
  #     environ
  #     cbfonts-fd
  #     xcolor;
  # });
in {
  environment.systemPackages =
    [
      pkgs.carapace
      pkgs.lnav
      pkgs.cmake
      pkgs.clang-tools
      pkgs.gh
      pkgs.broot
      pkgs.s3cmd
      pkgs.fzf
      pkgs.watch
      pkgs.up
      pkgs.fd
      pkgs.mosh
      pkgs.yazi
      #pkgs.ncdu
      unstable.neovim
      pkgs.tree-sitter
      pkgs.ripgrep
      pkgs.age
      pkgs.git
      pkgs.gnupg
      pkgs.yaml-language-server
      pkgs.direnv
      pkgs.glances
      pkgs.pipenv
      pkgs.rsync
      pkgs.shfmt
      pkgs.hunspell
      pkgs.aria2
      pkgs.git-crypt
      pkgs.git-lfs
      pkgs.rclone
      pkgs.aws-sam-cli
      pkgs.mtr
      unstable.devbox
      unstable.k9s
      unstable.fzy
      unstable.eza
      ];

  documentation = {
    doc.enable = false;
    man.enable = true;
    info.enable = false;
    enable = true;
  };
  system.primaryUser="gato";

  nix.extraOptions = ''
    auto-optimise-store = true
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  programs.nix-index.enable = true;

  fonts.packages = with pkgs; [
    proggyfonts
    fira-code
    fira-code-symbols
    nerd-fonts._0xproto
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.sauce-code-pro
    nerd-fonts.monoid
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.meslo-lg
    nerd-fonts.overpass
    nerd-fonts.bigblue-terminal
    nerd-fonts.iosevka
    nerd-fonts.gohufont
    nerd-fonts.hack
    nerd-fonts.monaspace
    nerd-fonts.agave
  ];

  environment.variables = rec {
     RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  #programs.zsh.zplug.enable = true;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  ids.gids.nixbld = 350;
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
    # "warpd" = {
    #   serviceConfig = {
    #     Label = "com.warpd.warpd";
    #     WorkingDirectory = (builtins.getEnv "HOME");
    #     EnvironmentVariables = { };
    #     KeepAlive = false;
    #     RunAtLoad =false;
    #     # StandardOutPath = "/var/tmp/warpd.log";
    #     StandardErrorPath = "/var/tmp/warpd.log";
    #     ProgramArguments = [ "/usr/local/bin/warpd" "-f" ];
    #     # ProgramArguments = [ "/Users/$USER/.bin/warpd" "-f" ];
    #     ProcessType = "Interactive";
    #     UserName = "$USER";
    #   };
    # };
  };

  homebrew = {
  enable = true;
  onActivation.upgrade = true;
  # updates homebrew packages on activation,
  # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
  taps = [
    "d12frosted/emacs-plus"
    "uptech/homebrew-oss"
    "homebrew/cask-fonts"
  ];
  brews = [
    {
      name = "emacs-plus@29";
      args = ["--with-modern-doom3-icon" "--with-poll" "--with-native-comp"];
    }
    "coder"
    "git-ps-rs"
    "mermaid-cli"
    "sqlite"
    "spoof-mac"
    "wireguard-go"
    "wireguard-tools"
    "lima"
  ];
  casks = [
    "shortcat"
    "mouseless"
    "ocenaudio"
    "telegram"
    "discord"
    "iterm2"
    "little-snitch"
    "macfuse"
    "gimp"
    "steam"
    "vlc"
    "fuse"
    "xnviewmp"
    "trezor-suite"
    "firefox"
    "cool-retro-term"
    "gimp"
    "veracrypt"
    "jetbrains-toolbox"
    "visual-studio-code"
    "hyper"
    "wireshark"
    "imhex"
    "rectangle"
    "warp"
    "cutter"
    "font-monaspace"
    "raycast"
    "whisky"
    "heroic"
    "blackhole-2ch"
  # "amneziawg"
  ];
  };

  nixpkgs.config.allowUnfree = true;
}
