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

# Optional: Add to PATH temporarily
if [ -t 0 ]; then  # Only prompt if running interactively
    read -p "Add to PATH temporarily? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        export PATH="$TEMP_DIR:$PATH"
        echo "✅ Added to PATH. Use 'toggle-subdisplay' directly in this session."
        echo "⚠️  Will be removed when terminal is closed."
    else
        echo "Use full path: $TEMP_DIR/toggle-subdisplay"
    fi
else
    echo "Use full path: $TEMP_DIR/toggle-subdisplay"
fi
