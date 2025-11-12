#!/bin/bash

# Build script for PyBasic release on Unix/Linux/macOS
# Creates a release folder with basic (uncompiled) and basic-bns (compiled executable)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RELEASE_DIR="$PROJECT_ROOT/release"
SRC_DIR="$PROJECT_ROOT/src"
BASIC_BNS_DIR="$SRC_DIR/basic-bns"

echo -e "${GREEN}=== PyBasic Release Builder (Linux/Unix/macOS) ===${NC}"
echo "Project root: $PROJECT_ROOT"

# Function to print colored messages
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if Python is available
check_python() {
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
    else
        print_error "Python not found. Please install Python 3.10 or later."
        exit 1
    fi
    
    # Check Python version
    PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
    print_info "Found Python $PYTHON_VERSION"
    
    # Check if version is 3.10+
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d'.' -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d'.' -f2)
    
    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 10 ]); then
        print_error "Python 3.10 or later required. Found $PYTHON_VERSION"
        exit 1
    fi
    
    print_status "Python version check passed"
}

# Clean the release directory
clean_release_dir() {
    print_info "Cleaning release directory..."
    if [ -d "$RELEASE_DIR" ]; then
        rm -rf "$RELEASE_DIR"
        print_status "Cleaned existing release directory"
    fi
    
    mkdir -p "$RELEASE_DIR"
    print_status "Created release directory: $RELEASE_DIR"
}

# Install required packages
install_requirements() {
    print_info "Installing/checking build requirements..."
    
    # Check if requirements file exists
    if [ ! -f "$PROJECT_ROOT/requirements-build.txt" ]; then
        print_warning "requirements-build.txt not found, installing PyInstaller manually"
        $PYTHON_CMD -m pip install pyinstaller pygame numpy
    else
        $PYTHON_CMD -m pip install -r "$PROJECT_ROOT/requirements-build.txt"
    fi
    
    print_status "Requirements installed"
}

# Copy basic script and dependencies
copy_basic_script() {
    print_info "Copying basic script and dependencies..."
    
    local basic_release_dir="$RELEASE_DIR/basic"
    mkdir -p "$basic_release_dir"
    
    # Copy the entire src/basic directory
    if [ -d "$SRC_DIR/basic" ]; then
        cp -r "$SRC_DIR/basic" "$basic_release_dir/"
        print_status "Copied basic interpreter modules"
    else
        print_error "Source directory $SRC_DIR/basic not found"
        exit 1
    fi
    
    # Copy the disassembler (needed by basic script)
    if [ -d "$SRC_DIR/disassembler" ]; then
        cp -r "$SRC_DIR/disassembler" "$basic_release_dir/"
        print_status "Copied disassembler modules"
    else
        print_warning "Disassembler directory not found"
    fi
    
    # Create a launcher script for basic
    cat > "$basic_release_dir/basic.py" << 'EOF'
#!/usr/bin/env python3
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))
from basic.basic import main

if __name__ == "__main__":
    main()
EOF
    
    # Make it executable
    chmod +x "$basic_release_dir/basic.py"
    
    # Create a shell wrapper for easier execution
    cat > "$basic_release_dir/basic" << 'EOF'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/basic.py" "$@"
EOF
    
    chmod +x "$basic_release_dir/basic"
    
    print_status "Basic script copied and configured"
}

# Build basic-bns executable using PyInstaller
build_basic_bns_executable() {
    print_info "Building basic-bns executable..."
    
    local bns_release_dir="$RELEASE_DIR/basic-bns"
    mkdir -p "$bns_release_dir"
    
    # Check if basic-bns.py exists
    if [ ! -f "$BASIC_BNS_DIR/basic-bns.py" ]; then
        print_error "basic-bns.py not found at $BASIC_BNS_DIR/basic-bns.py"
        exit 1
    fi
    
    # Create a spec file for PyInstaller
    local spec_file="$PROJECT_ROOT/basic-bns.spec"
    cat > "$spec_file" << EOF
# -*- mode: python ; coding: utf-8 -*-

import sys
import os
sys.path.append('$SRC_DIR')

a = Analysis(
    ['$BASIC_BNS_DIR/basic-bns.py'],
    pathex=['$SRC_DIR'],
    binaries=[],
    datas=[],
    hiddenimports=['disassembler.dc', 'disassembler.cmds', 'basic.lexer', 'basic.program', 'basic.basictoken', 'basic.flowsignal'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='basic-bns',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
EOF

    # Build with PyInstaller
    print_info "Running PyInstaller..."
    cd "$PROJECT_ROOT"
    
    $PYTHON_CMD -m PyInstaller \
        --clean \
        --distpath "$bns_release_dir" \
        "$spec_file"
    
    if [ $? -eq 0 ]; then
        print_status "basic-bns executable built successfully"
        
        # Make sure the executable is executable
        chmod +x "$bns_release_dir/basic-bns"
        
        # Clean up
        rm -f "$spec_file"
        [ -d "$PROJECT_ROOT/build" ] && rm -rf "$PROJECT_ROOT/build"
        
    else
        print_error "PyInstaller build failed"
        rm -f "$spec_file"
        exit 1
    fi
}

# Copy examples and documentation
copy_examples_and_docs() {
    print_info "Copying examples and documentation..."
    
    # Copy examples
    if [ -d "$PROJECT_ROOT/examples" ]; then
        cp -r "$PROJECT_ROOT/examples" "$RELEASE_DIR/"
        print_status "Examples copied"
    fi
    
    # Copy bt-examples
    if [ -d "$PROJECT_ROOT/bt-examples" ]; then
        cp -r "$PROJECT_ROOT/bt-examples" "$RELEASE_DIR/"
        print_status "BT Examples copied"
    fi
    
    # Copy bns_game_pack
    if [ -d "$PROJECT_ROOT/bns_game_pack" ]; then
        cp -r "$PROJECT_ROOT/bns_game_pack" "$RELEASE_DIR/"
        print_status "BNS Game Pack copied"
    fi
    
    # Copy docs
    if [ -d "$PROJECT_ROOT/docs" ]; then
        cp -r "$PROJECT_ROOT/docs" "$RELEASE_DIR/"
        print_status "Documentation copied"
    fi
    
    # Copy README and LICENSE
    for file in "README.md" "LICENSE"; do
        if [ -f "$PROJECT_ROOT/$file" ]; then
            cp "$PROJECT_ROOT/$file" "$RELEASE_DIR/"
            print_status "$file copied"
        fi
    done
}

# Create release README
create_release_readme() {
    print_info "Creating release README..."
    
    cat > "$RELEASE_DIR/README_RELEASE.md" << 'EOF'
# PyBasic Release (Linux/Unix)

This release contains two versions of the PyBasic interpreter:

## basic - Development Version (Uncompiled)
- Location: `basic/basic.py` or `basic/basic` (shell wrapper)
- Source code visible and editable
- Supports interactive mode with `-i` flag
- Runs .bas files (text format)

### Usage:
```bash
# Using the Python script directly
python3 basic/basic.py hello.bas

# Using the shell wrapper (easier)
./basic/basic hello.bas

# Interactive mode
./basic/basic -i

# Interactive mode with file
./basic/basic -i hello.bas
```

## basic-bns - Production Version (Compiled Executable)
- Location: `basic-bns/basic-bns`
- Compiled executable, source code protected
- NO interactive mode (for security)
- Runs .bas.bin files (compiled binary format)
- No Python installation required

### Usage:
```bash
# Run a compiled BASIC binary program
./basic-bns/basic-bns game.bas.bin

# Make sure it's executable (if needed)
chmod +x basic-bns/basic-bns
```

## Examples
- `examples/` - Regular BASIC programs (.bas files)
- `bt-examples/` - Additional BASIC examples
- `bns_game_pack/` - Binary game files (.bas.bin format)

## Documentation
- `docs/` - Language reference and documentation

## System Requirements
- **basic**: Python 3.10 or later
- **basic-bns**: No dependencies (standalone executable)

## Installation
1. Extract this archive to your preferred location
2. Make scripts executable: `chmod +x basic/basic basic-bns/basic-bns`
3. Optionally add to PATH for system-wide access

## Quick Test
```bash
# Test the uncompiled version
./basic/basic examples/hello.bas

# Test the compiled version (if .bas.bin files are available)
./basic-bns/basic-bns bns_game_pack/game.bas.bin
```
EOF
    
    print_status "Release README created"
}

# Create installation script
create_install_script() {
    print_info "Creating installation script..."
    
    cat > "$RELEASE_DIR/install.sh" << 'EOF'
#!/bin/bash

# Installation script for PyBasic

print_info() {
    echo -e "\033[0;34mℹ\033[0m $1"
}

print_status() {
    echo -e "\033[0;32m✓\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m✗\033[0m $1"
}

echo "=== PyBasic Installation ==="

# Get installation directory
if [ "$1" = "" ]; then
    INSTALL_DIR="/usr/local/bin"
else
    INSTALL_DIR="$1"
fi

print_info "Installing PyBasic to $INSTALL_DIR"

# Check if directory exists and is writable
if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Directory $INSTALL_DIR does not exist"
    exit 1
fi

if [ ! -w "$INSTALL_DIR" ]; then
    print_error "Cannot write to $INSTALL_DIR. Try running with sudo or choose a different directory."
    exit 1
fi

# Copy executables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$SCRIPT_DIR/basic/basic" ]; then
    cp "$SCRIPT_DIR/basic/basic" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/basic"
    print_status "basic installed"
fi

if [ -f "$SCRIPT_DIR/basic-bns/basic-bns" ]; then
    cp "$SCRIPT_DIR/basic-bns/basic-bns" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/basic-bns"
    print_status "basic-bns installed"
fi

print_status "Installation complete!"
print_info "You can now run 'basic' and 'basic-bns' from anywhere."
EOF
    
    chmod +x "$RELEASE_DIR/install.sh"
    print_status "Installation script created"
}

# Main build function
main() {
    echo
    print_info "Starting PyBasic release build process..."
    
    # Check prerequisites
    check_python
    
    # Install requirements
    install_requirements
    
    # Build steps
    clean_release_dir
    copy_basic_script
    build_basic_bns_executable
    copy_examples_and_docs
    create_release_readme
    create_install_script
    
    echo
    echo -e "${GREEN}=== Build Complete ===${NC}"
    echo "Release created in: $RELEASE_DIR"
    echo
    echo "Contents:"
    echo "- basic/          - Uncompiled Python script with shell wrapper"
    echo "- basic-bns/      - Compiled executable (no Python required)"
    echo "- examples/       - BASIC program examples"
    echo "- docs/           - Documentation"
    echo "- install.sh      - System installation script"
    echo "- README_RELEASE.md - Usage instructions"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Test the build: ./release/basic/basic examples/hello.bas"
    echo "2. Install system-wide: cd release && sudo ./install.sh"
    echo "3. Or distribute the entire release/ folder"
    echo
    
    return 0
}

# Run main function
main "$@"