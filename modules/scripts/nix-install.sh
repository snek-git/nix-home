#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for required dependencies
if ! command -v fzf >/dev/null 2>&1; then
    echo -e "${RED}Error: fzf is required but not installed${NC}"
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo -e "${RED}Error: jq is required but not installed${NC}"
    exit 1
fi

# Debug: Show script resolution
# echo -e "${YELLOW}Script source: ${BASH_SOURCE[0]}${NC}"
# echo -e "${YELLOW}Resolved script: $(readlink -f "${BASH_SOURCE[0]}")${NC}"

# Get the directory where the script is located (following symlinks)
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
PACKAGES_FILE="/home/snek/.config/home-manager/modules/packages.txt"

# Debug: Show resolved paths
# echo -e "${YELLOW}Script directory: $SCRIPT_DIR${NC}"
# echo -e "${YELLOW}Using packages file: $PACKAGES_FILE${NC}"
if [ ! -f "$PACKAGES_FILE" ]; then
    echo -e "${RED}Error: packages.txt not found at $PACKAGES_FILE${NC}"
    exit 1
fi

print_help() {
    echo "Nix Package Installer"
    echo "Usage: nix-install [OPTIONS] [PACKAGE_NAME]"
    echo ""
    echo "Options:"
    echo "  -s, --search    Search for a package (uses fzf)"
    echo "  -i, --install   Install and add package to home-manager config"
    echo "  -r, --remove    Remove package from home-manager config (uses fzf)"
    echo "  --help         Show this help message"
    echo ""
    echo "If no package name is provided with -s or -i, fzf will be used for selection"
}

search_package() {
    local query=$1
    local search_result
    
    if [ -z "$query" ]; then
        # Use fzf's built-in search capabilities
        search_result=$(echo "Type to search packages..." | fzf --ansi \
            --height 50% \
            --header 'Press ENTER to select, ESC to cancel' \
            --preview 'line={}; if [ "$line" != "Type to search packages..." ]; then nix search nixpkgs "^$line$" 2>/dev/null; fi' \
            --preview-window=right:50%:wrap \
            --bind "change:reload(if [ -n {q} ]; then nix search nixpkgs {q} 2>/dev/null | sed -n 's/^* legacyPackages.x86_64-linux.\([^ ]*\) .*/\1/p' | sort; else echo 'Type to search packages...'; fi)" \
            --disabled \
            --tiebreak=begin,length,index)
    else
        echo -e "${YELLOW}Searching for package: $query${NC}"
        search_result=$(nix search nixpkgs "$query" 2>/dev/null | \
            sed -n 's/^* legacyPackages.x86_64-linux.\([^ ]*\) .*/\1/p' | \
            sort | \
            fzf --ansi \
                --height 50% \
                --preview 'nix search nixpkgs "^{}" 2>/dev/null' \
                --preview-window=right:50%:wrap \
                --header 'Press ENTER to select a package, ESC to cancel')
    fi

    # Check if user selected anything
    if [ -z "$search_result" ] || [ "$search_result" = "Type to search packages..." ]; then
        echo -e "${RED}No package selected${NC}"
        return 1
    fi

    # Package name is the entire line since we're only showing package names
    package_name="$search_result"

    # Verify the package exists
    if ! nix-instantiate --eval -E "with import <nixpkgs> {}; $package_name" &>/dev/null; then
        echo -e "${RED}Selected package '$package_name' not found or invalid${NC}"
        return 1
    fi

    echo "$package_name"
}

remove_package() {
    local package=$1
    
    if [ -z "$package" ]; then
        # Interactive package selection for removal
        package=$(cat "$PACKAGES_FILE" |
            fzf --ansi \
                --height 50% \
                --preview 'nix eval nixpkgs#{} --raw' \
                --preview-window=right:50%:wrap \
                --header 'Select a package to remove (Press ENTER to select, ESC to cancel)')
        
        if [ -z "$package" ]; then
            echo -e "${RED}No package selected for removal${NC}"
            return 1
        fi
    fi
    
    echo -e "${YELLOW}Removing $package from Home Manager config...${NC}"
    
    # Check if package exists in the file
    if ! grep -Fx "$package" "$PACKAGES_FILE" > /dev/null 2>&1; then
        echo -e "${RED}Package '$package' is not installed!${NC}"
        return 1
    fi
    
    # Create a backup
    cp "$PACKAGES_FILE" "${PACKAGES_FILE}.bak"
    
    # Remove the package and any trailing empty lines
    sed -i "/^${package}\$/d" "$PACKAGES_FILE"
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$PACKAGES_FILE"
    
    echo -e "${YELLOW}Rebuilding Home Manager configuration...${NC}"
    home-manager switch
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Package '$package' has been removed and configuration updated!${NC}"
        rm "${PACKAGES_FILE}.bak"
    else
        echo -e "${RED}Failed to update configuration. Rolling back changes...${NC}"
        mv "${PACKAGES_FILE}.bak" "$PACKAGES_FILE"
        return 1
    fi
}

install_package() {
    local package=$1
    
    if [ -z "$package" ]; then
        # Interactive package selection for installation
        package=$(search_package)
        if [ -z "$package" ]; then
            return 1
        fi
    fi
    
    # First, verify the package exists
    if ! nix-instantiate --eval -E "with import <nixpkgs> {}; ${package}" &>/dev/null; then
        echo -e "${RED}Package '$package' not found or invalid!${NC}"
        return 1
    fi

    echo -e "${YELLOW}Adding $package to Home Manager config...${NC}"
    
    # Check if package is already installed
    if grep -Fx "$package" "$PACKAGES_FILE" > /dev/null 2>&1; then
        echo -e "${YELLOW}Package '$package' is already installed!${NC}"
        grep -n "$package" "$PACKAGES_FILE"
        return 0
    fi
    
    # Create a backup
    cp "$PACKAGES_FILE" "${PACKAGES_FILE}.bak"
    
    # Ensure the file ends with a newline
    [ -n "$(tail -c1 "$PACKAGES_FILE")" ] && echo >> "$PACKAGES_FILE"
    
    # Add package to the end of the file
    echo "$package" >> "$PACKAGES_FILE"
    
    echo -e "${YELLOW}Rebuilding Home Manager configuration...${NC}"
    home-manager switch
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Package '$package' has been added and configuration updated!${NC}"
        rm "${PACKAGES_FILE}.bak"
    else
        echo -e "${RED}Failed to update configuration. Rolling back changes...${NC}"
        mv "${PACKAGES_FILE}.bak" "$PACKAGES_FILE"
        return 1
    fi
}

# If no arguments provided, show help
if [ $# -eq 0 ]; then
    print_help
    exit 1
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--search)
            shift
            search_package "$1"
            exit $?
            ;;
        -i|--install)
            shift
            install_package "$1"
            exit $?
            ;;
        -r|--remove)
            shift
            remove_package "$1"
            exit $?
            ;;
        --help)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            print_help
            exit 1
            ;;
    esac
done 