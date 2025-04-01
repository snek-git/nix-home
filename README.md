# Nix Home Configuration

My personal [Home Manager](https://github.com/nix-community/home-manager) configuration.

## Setup

1. Install Nix:
```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Enable Flakes:
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

3. Clone this repository:
```bash
git clone https://github.com/snek-git/nix-home.git ~/.config/home-manager
```

4. Apply the configuration:
```bash
cd ~/.config/home-manager
home-manager switch --flake .#snek
```

## Structure

- `flake.nix`: The entry point of the configuration
- `home.nix`: Main home-manager configuration
- `modules/`: Directory containing various configuration modules
  - `shell/`: Shell-related configurations (zsh, etc.)
  - `programs/`: Program-specific configurations
  - `desktop/`: Desktop environment configurations
  - `services/`: Service configurations
  - `hyprland/`: Hyprland window manager configuration
  - `gaming/`: Gaming-related packages and configurations
  - `unstable-packages/`: Configurations using packages from unstable channels
  - `packages.nix`: Processes `packages.txt` to generate the list of installed packages, handles special package overrides and defines allowed unfree packages.
  - `packages.txt`: The primary list of package names to be installed (managed via `nix-install`).
  - `scripts/`: Helper scripts for managing the system (e.g., `nix-install`, `nix-update`, `game-launcher`).
    - `nix-install`: Package management script with fzf integration
    - `nix-update`: System update script

## Keybinds

### Core
- `Super + Return`: Open terminal (Kitty)
- `Super + Space`: Open application launcher (Wofi)
- `Super + B`: Open browser
- `Super + E`: Open file manager
- `Super + Q`: Close active window
- `Super + M`: Exit Hyprland
- `Super + V`: Toggle floating window
- `Super + J`: Toggle split direction

### Window Management
- `Super + Arrow`: Focus window in direction
- `Super + Shift + Arrow`: Move window in direction
- `Super + [1-0]`: Switch to workspace
- `Super + Shift + [1-0]`: Move window to workspace
- `Super + Mouse1`: Move window
- `Super + Mouse2`: Resize window
- `Super + R`: Enter resize mode
  - Use arrow keys to resize, Escape to exit

### Media Controls
- `Volume Keys`: Control volume
- `Media Keys`: Control media playback
- `Brightness Keys`: Control screen brightness

### Screenshots
- `Print`: Screenshot selected area (to clipboard)
- `Super + Print`: Screenshot selected area (to file)
- `Super + Shift + Print`: Screenshot full screen

### Other
- `Super + Alt + W`: Cycle through wallpapers

## Scripts

### nix-install
Interactive package management with fuzzy search:
```bash
# Interactive package search
nix-install -s

# Search specific package
nix-install -s package-name

# Interactive package install
nix-install -i

# Install specific package
nix-install -i package-name

# Interactive package removal
nix-install -r
```

### nix-update
A system update script with various options:
```bash
# Update everything (channels, system, and home-manager)
nix-update -a

# Update only channels
nix-update -c

# Update only system configuration
nix-update -s

# Update only home-manager configuration
nix-update -h
```

## Package Management

Packages are primarily managed by adding package names to `modules/packages.txt` and using the `nix-install` script. The script automatically:
- Verifies packages exist in nixpkgs
- Maintains a backup of the package list
- Rebuilds home-manager after changes
- Rolls back on failures

The `modules/packages.nix` file reads `packages.txt`, maps the names to Nix package attributes (handling special cases like nodePackages, nerd-fonts, etc.), adds specific overrides, and defines the `allowUnfreePredicate` list for necessary unfree packages.

## Updating

To update all flake inputs:
```bash
nix flake update
```

To update your entire system:
```bash
nix-update -a
```

To update specific components, use the appropriate flags with `nix-update` as shown in the Scripts section.

## AI Development Guidelines

This repository includes AI guidelines located at `.cursor/rules/nix_guidelines.txt`. These rules provide context and instructions to AI assistants (like Cursor) to help ensure consistency and adherence to the project's structure and conventions when making changes to the Nix configuration. 