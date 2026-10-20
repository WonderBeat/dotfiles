# Work laptop (hmnd).
{ lib, ... }:
{
  system.primaryUser = lib.mkForce "denis.golovachev";
  homebrew.casks = [ "paseo" "spacelauncher" "kitty" ];
  homebrew.brews = [ "emacs-plus@31" "nebula" ];
}
