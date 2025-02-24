{...}: {
  imports = let
    files = builtins.readDir ./.;
    nixFiles = builtins.filter
      (name: builtins.match ".*\\.nix" name != null && name != "default.nix")
      (builtins.attrNames files);
  in
    (map (name: ./. + "/${name}") nixFiles) ++ [
      ./hyprland
      ./waybar
    ];
} 