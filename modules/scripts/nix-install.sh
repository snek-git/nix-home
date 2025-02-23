#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Debug: Show script resolution
echo -e "${YELLOW}Script source: ${BASH_SOURCE[0]}${NC}"
echo -e "${YELLOW}Resolved script: $(readlink -f "${BASH_SOURCE[0]}")${NC}"

# Get the directory where the script is located (following symlinks)
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
PACKAGES_FILE="/home/snek/.config/home-manager/modules/packages.txt"

# Debug: Show resolved paths
echo -e "${YELLOW}Script directory: $SCRIPT_DIR${NC}"
echo -e "${YELLOW}Using packages file: $PACKAGES_FILE${NC}"
if [ ! -f "$PACKAGES_FILE" ]; then
    echo -e "${RED}Error: packages.txt not found at $PACKAGES_FILE${NC}"
    exit 1
fi

print_help() {
    echo "Nix Package Installer"
    echo "Usage: nix-install [OPTIONS] PACKAGE_NAME"
    echo ""
    echo "Options:"
    echo "  -s, --search    Search for a package"
    echo "  -i, --install   Install and add package to home-manager config"
    echo "  -r, --remove    Remove package from home-manager config"
    echo "  --help         Show this help message"
}

search_package() {
    local query=$1
    echo -e "${YELLOW}Searching for package: $query${NC}"
    
    # Use nix search with --json for better parsing
    local search_result
    search_result=$(nix search nixpkgs $query --json)
    
    if [ $? -ne 0 ] || [ "$search_result" = "{}" ]; then
        echo -e "${RED}No packages found matching '$query'${NC}"
        return 1
    fi
    
    # Parse and display results in a nice format
    echo "$search_result" | jq -r 'to_entries | .[] | "\n\(.key):\n  \(.value.description)\n  Version: \(.value.version)"'
}

remove_package() {
    local package=$1
    
    echo -e "${YELLOW}Removing $package from Home Manager config...${NC}"
    
    # Check if package exists in the file
    if ! grep -Fx "$package" "$PACKAGES_FILE" > /dev/null 2>&1; then
        echo -e "${RED}Package '$package' is not installed!${NC}"
        exit 1
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
        exit 1
    fi
}

install_package() {
    local package=$1
    
    # First, verify the package exists
    if ! nix-instantiate --eval -E "with import <nixpkgs> {}; ${package}" &>/dev/null; then
        echo -e "${RED}Package '$package' not found or invalid!${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Adding $package to Home Manager config...${NC}"
    
    # Debug: Show current packages
    echo -e "${YELLOW}Current packages in $PACKAGES_FILE:${NC}"
    cat "$PACKAGES_FILE"
    
    # Check if package is already installed (more precise check)
    if grep -Fx "$package" "$PACKAGES_FILE" > /dev/null 2>&1; then
        echo -e "${YELLOW}Package '$package' is already installed!${NC}"
        grep -n "$package" "$PACKAGES_FILE"
        exit 0
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
        exit 1
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
            shift
            ;;
        -i|--install)
            shift
            install_package "$1"
            shift
            ;;
        -r|--remove)
            shift
            remove_package "$1"
            shift
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