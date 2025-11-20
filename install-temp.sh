#!/bin/bash

# toggle-subdisplay temporary installer
# Clean installation without affecting system Homebrew

set -e

# Create temporary directory
TEMP_DIR=$(mktemp -d)
if [ ! -d "$TEMP_DIR" ]; then
    echo "Error: Failed to create temporary directory" >&2
    exit 1
fi

# Download binary
echo "Installing toggle-subdisplay..."
if ! curl -L -s -f https://github.com/keishimizu26629/toggle-subdisplay/releases/download/v0.1.0/toggle-subdisplay -o "$TEMP_DIR/toggle-subdisplay"; then
    echo "Error: Failed to download toggle-subdisplay" >&2
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Set executable permission
chmod +x "$TEMP_DIR/toggle-subdisplay"

# Verify installation
if ! "$TEMP_DIR/toggle-subdisplay" --query >/dev/null 2>&1; then
    echo "Error: Installation verification failed" >&2
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  $TEMP_DIR/toggle-subdisplay -q    # Check current state"
echo "  $TEMP_DIR/toggle-subdisplay       # Toggle display mode"
echo ""
echo "Cleanup when done:"
echo "  rm -rf $TEMP_DIR"
echo ""

# How to use toggle-subdisplay command directly
echo "📋 To use 'toggle-subdisplay' command directly, choose one of these options:"
echo ""
echo "Option 1: Add to PATH temporarily (this session only)"
echo "  export PATH=\"$TEMP_DIR:\$PATH\""
echo "  toggle-subdisplay -q"
echo ""
echo "Option 2: Install to system (permanent, requires sudo)"
echo "  sudo cp $TEMP_DIR/toggle-subdisplay /usr/local/bin/"
echo "  toggle-subdisplay -q"
echo ""
echo "Option 3: Use Homebrew (recommended for permanent installation)"
echo "  brew tap keishimizu26629/tap"
echo "  brew install toggle-subdisplay"
echo "  toggle-subdisplay -q"
echo ""
echo "Option 4: Use full path (no setup required)"
echo "  $TEMP_DIR/toggle-subdisplay -q"
echo ""
echo "💡 Copy and run any of the above commands to get started!"
