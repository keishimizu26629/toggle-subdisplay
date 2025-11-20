# 🖥️ toggle-subdisplay

A lightweight CLI tool for macOS to toggle between mirror and extended display modes.

## 📋 Overview

`toggle-subdisplay` allows you to quickly switch between mirrored and extended display modes on macOS when using an internal display + one external display setup.

### ✨ Features

- **Simple**: One command to toggle between mirror ⇄ extended modes
- **Safe**: Does nothing when conditions aren't met (0 or 2+ external displays)
- **Lightweight**: Pure Swift + CoreGraphics, no external dependencies
- **Scriptable**: Clear exit codes and state query API

### 🎯 Use Cases

- **Presentations**: Quickly switch to mirror mode for presentations
- **Development**: Toggle to extended mode for more screen real estate
- **Automation**: Integrate into scripts or shortcuts
- **Temporary setups**: Perfect for shared or temporary workstations

## 🚀 Installation

### Quick Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/keishimizu26629/toggle-subdisplay/main/install-temp.sh | bash
```

After installation, you'll see options to use `toggle-subdisplay` command directly:

#### Option 1a: Temporary PATH (this session only)
```bash
export PATH="/tmp/xxx:$PATH"  # Use the path shown in installer output
toggle-subdisplay -q
```

#### Option 1b: Permanent PATH via shell config
```bash
echo 'export PATH="/tmp/xxx:$PATH"' >> ~/.zshrc  # Use actual path from installer
source ~/.zshrc
toggle-subdisplay -q
```

#### Option 2a: System installation (permanent, requires sudo)
```bash
sudo cp /tmp/xxx/toggle-subdisplay /usr/local/bin/  # Use the path from installer
toggle-subdisplay -q
```

#### Option 2b: User bin installation (permanent, no sudo)
```bash
mkdir -p ~/bin
cp /tmp/xxx/toggle-subdisplay ~/bin/  # Use the path from installer
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
toggle-subdisplay -q
```

#### Option 3: Homebrew (recommended for permanent use)
```bash
brew tap keishimizu26629/tap
brew install toggle-subdisplay
toggle-subdisplay -q
```

#### Option 4: Full path (no setup required)
```bash
/tmp/xxx/toggle-subdisplay -q  # Use the exact path from installer output
```

### Installation Methods Comparison

| Method | Command Usage | Persistence | System Impact | Sudo Required |
|--------|---------------|-------------|---------------|---------------|
| **Temporary PATH** | `toggle-subdisplay` | Session only | None | No |
| **Permanent PATH** | `toggle-subdisplay` | Permanent | Shell config | No |
| **System Install** | `toggle-subdisplay` | Permanent | System-wide | Yes |
| **User Bin** | `toggle-subdisplay` | Permanent | User-only | No |
| **Homebrew** | `toggle-subdisplay` | Permanent | Standard | No |
| **Full Path** | `/tmp/xxx/toggle-subdisplay` | Temporary | None | No |

## 📖 Usage

### Basic Commands

```bash
# Check current display state
toggle-subdisplay --query
toggle-subdisplay -q

# Toggle between mirror and extended modes
toggle-subdisplay
```

### Display States

| State | Description |
|-------|-------------|
| `on` | Mirror mode (displays show same content) |
| `off` | Extended mode (displays show different content) |
| `none` | Unsupported configuration (0 or 2+ external displays) |

### Supported Configurations

| Display Setup | Behavior |
|---------------|----------|
| **Internal + 1 external** | ✅ Toggle between mirror ⇄ extended |
| **Internal only** | ⚠️ Returns `none`, no action taken |
| **2+ external displays** | ⚠️ Returns `none`, no action taken |

## 💡 Examples

### Basic Usage

```bash
# Check what mode you're currently in
$ toggle-subdisplay -q
off

# Switch to mirror mode
$ toggle-subdisplay
$ toggle-subdisplay -q
on

# Switch back to extended mode
$ toggle-subdisplay
$ toggle-subdisplay -q
off
```

### Scripting Examples

```bash
#!/bin/bash
# presentation-mode.sh

current_state=$(toggle-subdisplay -q)

if [ "$current_state" = "none" ]; then
    echo "No external display detected"
    exit 1
fi

if [ "$current_state" = "off" ]; then
    echo "Switching to presentation mode (mirror)..."
    toggle-subdisplay
else
    echo "Switching to work mode (extended)..."
    toggle-subdisplay
fi
```

### Integration with Shortcuts (macOS)

1. Open Shortcuts app
2. Create new shortcut
3. Add "Run Shell Script" action
4. Enter: `toggle-subdisplay`
5. Assign keyboard shortcut

## 🔧 Technical Details

### Requirements

- **OS**: macOS 10.15 (Catalina) or later
- **Hardware**: Mac with internal display + external display capability
- **Permissions**: No special permissions required

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success (toggle completed or unsupported config) |
| `1` | Error (CoreGraphics API failure) |

### Performance

- **Startup time**: < 50ms
- **Memory usage**: < 5MB
- **Binary size**: ~70KB

## 🧪 Testing

### Manual Testing

```bash
# Test 1: No external display
toggle-subdisplay -q  # Should return "none"

# Test 2: One external display connected
toggle-subdisplay -q  # Should return "on" or "off"
toggle-subdisplay     # Should toggle the mode

# Test 3: Multiple external displays
toggle-subdisplay -q  # Should return "none"
```

### Automated Testing

```bash
# Test script example
#!/bin/bash
state=$(toggle-subdisplay -q)
if [[ "$state" =~ ^(on|off|none)$ ]]; then
    echo "✅ State query working: $state"
else
    echo "❌ Invalid state: $state"
    exit 1
fi
```

## 🛠️ Development

### Building from Source

```bash
git clone https://github.com/keishimizu26629/toggle-subdisplay.git
cd toggle-subdisplay
swift build -c release

# Binary will be at: .build/release/toggle-subdisplay
```

### Project Structure

```
toggle-subdisplay/
├── Package.swift                    # Swift Package Manager config
├── Sources/toggle-subdisplay/
│   ├── main.swift                   # CLI entry point
│   ├── DisplayMirrorService.swift   # Core display logic
│   └── DisplayError.swift           # Error definitions
└── install-temp.sh                  # Temporary installer
```

## 🔒 Security & Privacy

- **No network access**: Works entirely offline
- **No data collection**: No telemetry or analytics
- **No elevated permissions**: Runs with user privileges
- **No system modification**: Uses standard CoreGraphics APIs

## 🐛 Troubleshooting

### Common Issues

**"none" returned when external display is connected**
- Ensure display is properly detected by macOS
- Try disconnecting and reconnecting the display
- Check System Preferences > Displays

**Command not found**
- If using temporary install, use full path provided by installer
- If using Homebrew, ensure `/opt/homebrew/bin` is in your PATH

**Permission denied**
- Ensure the binary has execute permissions: `chmod +x toggle-subdisplay`

### Debug Information

```bash
# Check display configuration
system_profiler SPDisplaysDataType

# Check if binary is executable
ls -la /path/to/toggle-subdisplay
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/keishimizu26629/toggle-subdisplay/issues)
- **Discussions**: [GitHub Discussions](https://github.com/keishimizu26629/toggle-subdisplay/discussions)

---

**Made with ❤️ for the macOS community**
