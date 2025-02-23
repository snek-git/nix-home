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
  - `packages.nix`: List of all installed packages
- `scripts/`: Custom scripts and utilities
  - `packages.txt`: List of packages to be installed via pip/npm/etc.
  - `install_packages.sh`: Script to install packages from packages.txt
  - `update_packages.sh`: Script to update packages.txt with current pip/npm packages

## Package Management

### Nix Packages
All Nix packages are managed in `modules/packages.nix`. To add a new package:
1. Find it on [search.nixos.org](https://search.nixos.org)
2. Add it to the packages list in `modules/packages.nix`
3. Run `home-manager switch --flake .#snek`

### External Packages (pip, npm, etc.)
Non-Nix packages are managed through `scripts/packages.txt`:
- To install listed packages: `./scripts/install_packages.sh`
- To update packages.txt with current packages: `./scripts/update_packages.sh`
- Format: `type:package_name:version` (e.g., `pip:requests:2.28.1`)

## Updating

To update all flake inputs:
```bash
nix flake update
```

To update and apply changes:
```bash
home-manager switch --flake .#snek
```

To update external packages:
```bash
./scripts/update_packages.sh  # Updates packages.txt
./scripts/install_packages.sh # Installs/updates packages from packages.txt 