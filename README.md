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
  - `scripts/`: Helper scripts for managing the system
    - `nix-install`: Package management script
    - `nix-update`: System update script

## Scripts

### nix-install
A package management script for easily searching, installing, and removing packages:
```bash
# Search for a package
nix-install -s package-name

# Install a package
nix-install -i package-name

# Remove a package
nix-install -r package-name
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

### Nix Packages
All Nix packages are managed in `modules/packages.nix`. To manage packages:
1. Use `nix-install` to search and install packages
2. Packages are automatically added to your configuration
3. Use `nix-update` to update your system

### Package Storage and Handling

The package management system is designed to be declarative and reproducible:

1. **Package List**: 
   - All packages are listed in `modules/packages.txt`
   - Each package is stored on its own line
   - The file is automatically managed by `nix-install`

2. **Package Installation**:
   - When you run `nix-install -i package-name`:
     1. The script verifies the package exists in nixpkgs
     2. Adds it to `packages.txt`
     3. Creates a backup before modifying
     4. Automatically rebuilds your home-manager configuration

3. **Package Removal**:
   - When you run `nix-install -r package-name`:
     1. The script removes the package from `packages.txt`
     2. Creates a backup before modifying
     3. Automatically rebuilds your configuration
     4. Rolls back changes if the rebuild fails

4. **Package Updates**:
   - Packages are updated through the normal Nix channels
   - Running `nix-update` will update all packages to their latest versions
   - Individual packages always match the version in your current Nix channel

5. **Rollback Safety**:
   - All operations create backups before modifying
   - Failed operations automatically roll back to the previous state
   - Your system remains in a working state even if operations fail

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