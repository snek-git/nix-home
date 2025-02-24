{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "snek";
  home.homeDirectory = "/home/snek";

  home.stateVersion = "24.11"; 
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Import all modules
  imports = [
    ./modules/packages.nix
    ./modules/shell
    ./modules/programs
    ./modules/desktop
    ./modules/services
    ./modules/hyprland
  ];
}