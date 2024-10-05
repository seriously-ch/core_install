#!/bin/sh

# Configuration
REPO_URL="git@github.com:seriously-ch/core.git"
SUBMODULE_PATH="core"
SETUP_SCRIPT="bin/setup.exs"

# Emoji definitions
EMOJI_SUCCESS="✅"
EMOJI_ERROR="❌"
EMOJI_INFO="ℹ️"
EMOJI_WARN="⚠️"

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "$EMOJI_ERROR Git is not installed. Please install git and try again."
    exit 1
fi

# Check if the current directory is a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "$EMOJI_ERROR Current directory is not a git repository. Please run this script from within a git repository."
    exit 1
fi

# Add the repository as a submodule
echo "$EMOJI_INFO Adding submodule..."
if git submodule add "$REPO_URL" "$SUBMODULE_PATH"; then
    echo "$EMOJI_SUCCESS Submodule added successfully."
else
    echo "$EMOJI_ERROR Failed to add submodule. Exiting."
    exit 1
fi

# Initialize and update the submodule
echo "$EMOJI_INFO Initializing and updating submodule..."
if git submodule update --init --recursive; then
    echo "$EMOJI_SUCCESS Submodule initialized and updated."
else
    echo "$EMOJI_ERROR Failed to initialize and update submodule. Exiting."
    exit 1
fi

# Check if the setup script exists
if [ ! -f "$SUBMODULE_PATH/$SETUP_SCRIPT" ]; then
    echo "$EMOJI_ERROR $SETUP_SCRIPT not found in the submodule. Exiting."
    exit 1
fi

# Check if elixir is installed
if ! command -v elixir >/dev/null 2>&1; then
    echo "$EMOJI_WARN Elixir is not installed. Please install Elixir and try again."
    exit 1
fi

# Run the setup script
echo "$EMOJI_INFO Running $SETUP_SCRIPT..."
if elixir "$SUBMODULE_PATH/$SETUP_SCRIPT"; then
    echo "$EMOJI_SUCCESS Setup completed successfully!"
else
    echo "$EMOJI_ERROR Setup script failed. Please check the error messages above."
    exit 1
fi
