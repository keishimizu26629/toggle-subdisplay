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

# Installation options
if [ -t 0 ]; then  # Only prompt if running interactively
    echo "Installation options:"
    echo "1) Use full path (safest, no system changes)"
    echo "2) Add to PATH temporarily (this session only)"
    echo "3) Install to /usr/local/bin (permanent, requires sudo)"
    echo "4) Show Homebrew installation command"
    echo ""
    read -p "Choose option (1-4) [1]: " -n 1 -r
    echo
    
    case $REPLY in
        2)
            export PATH="$TEMP_DIR:$PATH"
            echo "✅ Added to PATH temporarily. Use 'toggle-subdisplay' directly."
            echo "⚠️  Will be removed when terminal is closed."
            ;;
        3)
            if sudo -n true 2>/dev/null; then
                # sudo available without password
                sudo cp "$TEMP_DIR/toggle-subdisplay" /usr/local/bin/
                echo "✅ Installed to /usr/local/bin/toggle-subdisplay (permanent)"
                echo "💡 You can now use 'toggle-subdisplay' from anywhere"
            else
                echo "Installing to /usr/local/bin (requires password):"
                if sudo cp "$TEMP_DIR/toggle-subdisplay" /usr/local/bin/ 2>/dev/null; then
                    echo "✅ Installed to /usr/local/bin/toggle-subdisplay (permanent)"
                    echo "💡 You can now use 'toggle-subdisplay' from anywhere"
                else
                    echo "❌ Installation failed. Use option 1 or 2 instead."
                    echo "Use full path: $TEMP_DIR/toggle-subdisplay"
                fi
            fi
            ;;
        4)
            echo "For permanent Homebrew installation:"
            echo "  brew tap keishimizu26629/tap"
            echo "  brew install toggle-subdisplay"
            echo ""
            echo "Current temporary installation:"
            echo "Use full path: $TEMP_DIR/toggle-subdisplay"
            ;;
        *)
            echo "Using full path method (safest):"
            echo "Use: $TEMP_DIR/toggle-subdisplay"
            ;;
    esac
else
    # Non-interactive mode
    if [ "$INSTALL_METHOD" = "system" ] && command -v sudo >/dev/null; then
        if sudo -n cp "$TEMP_DIR/toggle-subdisplay" /usr/local/bin/ 2>/dev/null; then
            echo "✅ Installed to /usr/local/bin/toggle-subdisplay"
        else
            echo "Use full path: $TEMP_DIR/toggle-subdisplay"
        fi
    else
        echo "Use full path: $TEMP_DIR/toggle-subdisplay"
    fi
fi
