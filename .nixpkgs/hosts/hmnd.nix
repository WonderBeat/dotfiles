# Work laptop (hmnd).
{ lib, pkgs, ... }:
let
  zhist-src = pkgs.fetchzip {
    url = "https://github.com/overflowy/zhist/releases/download/v1.2.2/zhist_1.2.2_darwin_arm64.tar.gz";
    hash = "sha256-XuP854ghAywWTceKGkXGnUfFaoKdLS74iKoyj5PepjQ=";
    stripRoot = false;
  };
  zhist = pkgs.runCommandLocal "zhist" { } ''
    mkdir -p "$out/bin"
    cp "${zhist-src}/zhist" "$out/bin/zhist"
  '';
in {
  system.primaryUser = lib.mkForce "denis.golovachev";
  homebrew.casks = [ "paseo" "spacelauncher" "kitty" ];
  homebrew.brews = [ "emacs-plus@31" "nebula" ];
  environment.systemPackages = [ pkgs.zoxide zhist ];
}
