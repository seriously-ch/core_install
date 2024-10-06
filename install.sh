#!/bin/bash

# Configuration
REPO_URL="https://github.com/seriously-ch/core.git"
SUBMODULE_PATH=".core"

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print styled messages
print_styled() {
    case "$1" in
        "success") echo -e "${GREEN}✅ $2${NC}" ;;
        "info") echo -e "${BLUE}ℹ️ $2${NC}" ;;
        "error") echo -e "${RED}❌ Error: $2${NC}" >&2 ;;
        "warn") echo -e "${YELLOW}⚠️ $2${NC}" ;;
    esac
}

# Function to execute command and show output on error
execute() {
    if ! output=$("$@" 2>&1); then
        print_styled "error" "Command failed: $1"
        echo "$output"
        exit 1
    fi
}

# Function to uninstall
uninstall() {
    print_styled "info" "Uninstalling existing Core..."
    if [[ -d "$SUBMODULE_PATH" ]]; then
        execute git submodule deinit -f "$SUBMODULE_PATH"
        execute rm -rf "$SUBMODULE_PATH"
        execute rm -rf ".git/modules/$SUBMODULE_PATH"
    fi

    if [[ -d ".githooks" ]]; then
        execute rm -rf ".githooks"
    fi

    # Remove submodule entry from .gitmodules file
    if [[ -f ".gitmodules" ]]; then
        execute sed -i.bak "/\\[submodule \"$SUBMODULE_PATH\"\\]/,/^$/d" .gitmodules
        execute rm -f .gitmodules.bak
        # Remove .gitmodules if it's empty
        [[ -s ".gitmodules" ]] || rm .gitmodules
    fi

    print_styled "success" "Uninstallation completed"
}

# Function to add submodule
add_submodule() {
    print_styled "info" "Adding Core submodule..."

    # Remove existing submodule directory if it exists
    [[ -d "$SUBMODULE_PATH" ]] && rm -rf "$SUBMODULE_PATH"

    # Add the submodule
    execute touch .gitmodules
    execute git submodule add --force "$REPO_URL" "$SUBMODULE_PATH"

    print_styled "success" "Submodule added successfully"
}

# Function to run setup task
run_setup_task() {
    print_styled "info" "Running setup task..."
    local current_dir=$(pwd)
    cd "$SUBMODULE_PATH" || exit 1
    execute mix deps.get
    execute mix core setup --cwd "$current_dir"
    cd "$current_dir" || exit 1
    print_styled "success" "Setup task completed"
}

# Main execution
uninstall
add_submodule
run_setup_task

print_styled "success" "Core installation completed successfully!"
print_styled "warn" "The Core submodule has been added, but changes have not been committed."
print_styled "info" "Review the changes with 'git status' and commit them when ready."
