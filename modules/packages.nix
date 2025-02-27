{pkgs, lib, ...}: let
  # Read and parse packages.txt
  packagesFile = builtins.readFile ./packages.txt;
  packageLines = lib.splitString "\n" packagesFile;
  
  # Function to get package from name
  getPackage = name:
    let
      # Special cases for packages in subsets
      specialCases = {
        # Node packages
        "typescript-language-server" = pkgs.nodePackages.typescript-language-server;
        "vscode-langservers-extracted" = pkgs.nodePackages.vscode-langservers-extracted;
        
        # KDE packages
        "kate" = pkgs.kdePackages.kate;
        
        # Wine packages
        "wine-stable" = pkgs.wineWowPackages.stable;
        
        # Nerd fonts
        "fira-code" = pkgs.nerd-fonts.fira-code;
        "jetbrains-mono" = pkgs.nerd-fonts.jetbrains-mono;
        "hack" = pkgs.nerd-fonts.hack;

        # JetBrains packages
        "pycharm-community" = pkgs.jetbrains.pycharm-community;
        
        # GStreamer packages
        "gst_all_1.gstreamer" = pkgs.gst_all_1.gstreamer;
        "gst_all_1.gst-plugins-base" = pkgs.gst_all_1.gst-plugins-base;
        "gst_all_1.gst-plugins-good" = pkgs.gst_all_1.gst-plugins-good;
        "gst_all_1.gst-plugins-bad" = pkgs.gst_all_1.gst-plugins-bad;
        "gst_all_1.gst-plugins-ugly" = pkgs.gst_all_1.gst-plugins-ugly;
        "gst_all_1.gst-libav" = pkgs.gst_all_1.gst-libav;
      };
    in
      specialCases.${name} or pkgs.${name};

  # Filter out empty lines and comments, then map to packages
  regularPackages = builtins.map 
    (line: getPackage line) (
    builtins.filter (line: 
      line != "" && 
      !(lib.hasPrefix "#" line)
    ) packageLines
  );

  # Special packages that need custom handling
  specialPackages = with pkgs; [
    (terraform.overrideAttrs (old: { doCheck = false; }))
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
  ];

in {
  nixpkgs.config.allowUnfree = true;
  home.packages = regularPackages ++ specialPackages;
} 