#!/bin/bash
set -e

REPO="muava12/picoclaw-dashboard"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="picoclaw-dashboard"
SYMLINK_NAME="picodash"
VERSION_FILE="$HOME/.picoclaw_version"

echo "Checking latest release of $REPO..."

# Fetch the latest release tag from GitHub API
LATEST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep -o '"tag_name": "[^"]*' | grep -o '[^"]*$')

if [ -z "$LATEST_TAG" ]; then
    echo "Error: Failed to fetch the latest release tag. Please check your internet connection or GitHub API rate limits."
    exit 1
fi

echo "Latest version available: $LATEST_TAG"

# Check if the requested version is already installed
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE" 2>/dev/null || true)
    if [ "$CURRENT_VERSION" = "$LATEST_TAG" ] && command -v $BINARY_NAME >/dev/null; then
        echo "✅ Version $LATEST_TAG is already installed."
        echo "You can launch it by running: '$BINARY_NAME' or '$SYMLINK_NAME'."
        exit 0
    fi
fi

echo "⬇️ Downloading $LATEST_TAG for Linux arm64..."
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_TAG/${BINARY_NAME}_Linux_arm64.tar.gz"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if ! curl -sSLf "$DOWNLOAD_URL" -o picoclaw.tar.gz; then
    echo "Error: Failed to download the release from $DOWNLOAD_URL"
    cd "$HOME"
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "📦 Extracting archive..."
tar -xzf picoclaw.tar.gz

echo "⚙️ Installing to $INSTALL_DIR..."
# Check if sudo is needed for /usr/local/bin
SUDO=""
if [ ! -w "$INSTALL_DIR" ]; then
    echo "Requesting sudo privileges to install binaries into $INSTALL_DIR..."
    SUDO="sudo"
fi

$SUDO mv $BINARY_NAME "$INSTALL_DIR/$BINARY_NAME"
$SUDO chmod +x "$INSTALL_DIR/$BINARY_NAME"

# Create symlink 'picodash'
if [ -L "$INSTALL_DIR/$SYMLINK_NAME" ] || [ -f "$INSTALL_DIR/$SYMLINK_NAME" ]; then
    $SUDO rm -f "$INSTALL_DIR/$SYMLINK_NAME"
fi
$SUDO ln -s "$INSTALL_DIR/$BINARY_NAME" "$INSTALL_DIR/$SYMLINK_NAME"

# Save the installed version locally to prevent redundant downloads
echo "$LATEST_TAG" > "$VERSION_FILE"

# Clean up temporary files
cd "$HOME"
rm -rf "$TMP_DIR"

echo "✨ Installation complete! ✨"
echo "You can now run the application from anywhere using:"
echo "  $BINARY_NAME"
echo "  or simply:"
echo "  $SYMLINK_NAME"
