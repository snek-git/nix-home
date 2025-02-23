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

## Updating

To update all flake inputs:
```bash
nix flake update
```

To update and apply changes:
```bash
home-manager switch --flake .#snek
``` 