# Work laptop (hmnd).
{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
    };
  };
  zhist-src = pkgs.fetchzip {
    url = "https://github.com/overflowy/zhist/releases/download/v1.2.2/zhist_1.2.2_darwin_arm64.tar.gz";
    hash = "sha256-XuP854ghAywWTceKGkXGnUfFaoKdLS74iKoyj5PepjQ=";
    stripRoot = false;
  };
  zhist = pkgs.runCommandLocal "zhist" { } ''
    mkdir -p "$out/bin"
    cp "${zhist-src}/zhist" "$out/bin/zhist"
  '';
in
{
  system.primaryUser = lib.mkForce "denis.golovachev";
  homebrew.casks = [
    "paseo"
    "spacelauncher"
    "kitty"
  ];
  homebrew.brews = [
    "emacs-plus@31"
    "nebula"
  ];
  # jujutsu and uv come from darwin-configuration.nix (unstable).
  environment.systemPackages = [
    zhist
    unstable.gg-jj
    pkgs.zoxide
    pkgs.terraform
    pkgs.gnuplot
    pkgs.dockfmt
    pkgs.zig
    pkgs.rust-analyzer
  ];
}
