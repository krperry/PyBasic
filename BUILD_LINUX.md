# Building PyBasic on Linux

This guide covers building PyBasic releases specifically for Linux and Unix-like systems.

## Quick Start

### Using Make (Recommended)
```bash
# Build everything
make

# Clean and rebuild
make clean build

# Build and test
make test

# Build and install system-wide
make install

# Build and install to user directory
make install-user

# Create distributable package
make package
```

### Using the Build Script Directly
```bash
# Make executable and run
chmod +x build_release.sh
./build_release.sh
```

### Manual Build
```bash
# Install dependencies
pip3 install -r requirements-build.txt

# Run Python build script
python3 build_release.py
```

## Prerequisites

### System Requirements
- Linux, macOS, or other Unix-like system
- Python 3.10 or later
- pip3 (Python package installer)
- Basic development tools (gcc, make - usually pre-installed)

### Installing Python 3.10+ on Various Distros

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install python3 python3-pip python3-dev
```

#### CentOS/RHEL/Fedora
```bash
# CentOS/RHEL
sudo yum install python3 python3-pip python3-devel

# Fedora
sudo dnf install python3 python3-pip python3-devel
```

#### Arch Linux
```bash
sudo pacman -S python python-pip
```

#### macOS (using Homebrew)
```bash
brew install python@3.11
```

## Build Process Details

### What the Build Script Does

1. **Environment Check**: Verifies Python 3.10+ is available
2. **Dependencies**: Installs PyInstaller, pygame, numpy
3. **Clean**: Removes any existing release directory
4. **Copy Source**: Copies uncompiled `basic` with all dependencies
5. **Compile**: Creates standalone `basic-bns` executable
6. **Examples**: Copies example programs and documentation
7. **Wrappers**: Creates shell wrappers for easy execution
8. **Package**: Creates complete release structure

### Output Structure
```
release/
├── basic/                    # Uncompiled version
│   ├── basic                # Shell wrapper script
│   ├── basic.py            # Python launcher
│   ├── basic/              # BASIC interpreter modules  
│   └── disassembler/       # Disassembler modules
├── basic-bns/              # Compiled version
│   └── basic-bns           # Standalone executable
├── examples/               # Example .bas files
├── bt-examples/           # Additional examples
├── bns_game_pack/         # Compiled .bas.bin games
├── docs/                  # Documentation
├── install.sh             # System installer
└── README_RELEASE.md      # Usage instructions
```

## Installation Options

### Option 1: System-Wide Installation
```bash
cd release
sudo ./install.sh
# Installs to /usr/local/bin
```

### Option 2: User Directory Installation  
```bash
cd release
./install.sh ~/.local/bin
# Make sure ~/.local/bin is in your PATH
```

### Option 3: Manual PATH Setup
```bash
# Add release directory to PATH
export PATH="$PWD/release/basic:$PWD/release/basic-bns:$PATH"

# Make permanent by adding to ~/.bashrc
echo 'export PATH="'$PWD'/release/basic:'$PWD'/release/basic-bns:$PATH"' >> ~/.bashrc
```

## Testing the Build

### Quick Test
```bash
# Test uncompiled version
./release/basic/basic examples/hello.bas

# Test compiled version (if .bas.bin files available)  
./release/basic-bns/basic-bns bns_game_pack/game.bas.bin
```

### Comprehensive Test
```bash
make test
```

## Distribution

### Create Package for Distribution
```bash
make package
# Creates: pybasic-release-Linux-x86_64.tar.gz
```

### Extract Package on Target System
```bash
tar -xzf pybasic-release-Linux-x86_64.tar.gz
cd pybasic-release-Linux-x86_64
chmod +x basic/basic basic-bns/basic-bns
./install.sh  # Optional system install
```

## Troubleshooting

### Common Issues

#### "Python 3.10 required"
```bash
# Check your Python version
python3 --version

# On older systems, install newer Python
# Ubuntu: use deadsnakes PPA
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 python3.11-pip
```

#### "Permission denied" on executables
```bash
chmod +x build_release.sh
chmod +x release/basic/basic
chmod +x release/basic-bns/basic-bns
```

#### PyInstaller build fails
```bash
# Install development headers
sudo apt install python3-dev  # Ubuntu/Debian
sudo yum install python3-devel # CentOS/RHEL

# Clear pip cache
pip3 cache purge
```

#### "basic-bns: command not found"
```bash
# Make sure it's executable
chmod +x release/basic-bns/basic-bns

# Check if it runs directly
./release/basic-bns/basic-bns --help

# Add to PATH
export PATH="$PWD/release/basic-bns:$PATH"
```

### Debug Mode
```bash
# Run build with verbose output
bash -x build_release.sh

# Check PyInstaller logs
cat build.log  # If build fails
```

## Cross-Platform Considerations

### Building for Different Architectures
```bash
# Build native to current system
make build

# For 32-bit on 64-bit system (requires multilib)
linux32 make build
```

### Platform-Specific Features
- **Linux**: Creates portable executable with embedded Python
- **macOS**: May require code signing for distribution
- **Alpine Linux**: May need musl-compatible Python build

## Advanced Configuration

### Customizing the Build

#### Modify Build Variables
Edit `build_release.sh`:
```bash
# Change release directory
RELEASE_DIR="$PROJECT_ROOT/dist"

# Add custom Python paths
export PYTHONPATH="/custom/path:$PYTHONPATH"
```

#### Custom PyInstaller Options
Edit the spec file generation in `build_basic_bns_executable()`:
```bash
# Add more hidden imports
hiddenimports=['disassembler.dc', 'custom.module']

# Enable debug mode
debug=True
```

## Performance Optimization

### Reducing Executable Size
```bash
# Install UPX for compression
sudo apt install upx-ucl  # Ubuntu/Debian
sudo yum install upx      # CentOS/RHEL

# UPX is automatically used if available
```

### Faster Builds
```bash
# Use faster Python implementation
python3 -O build_release.py

# Parallel builds (if modified for threading)
make -j$(nproc) build
```

This comprehensive build system ensures you can reliably create Linux distributions of both the development (`basic`) and production (`basic-bns`) versions of PyBasic!