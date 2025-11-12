# Building PyBasic Release

This document explains how to build a release package containing both the uncompiled `basic` script and the compiled `basic-bns` executable.

## Quick Start

### Windows
```batch
# Option 1: Batch file
build_release.bat

# Option 2: PowerShell
PowerShell -ExecutionPolicy Bypass -File build_release.ps1

# Option 3: Manual
pip install -r requirements-build.txt
python build_release.py
```

### Linux/macOS
```bash
# Make executable and run
chmod +x build_release.sh
./build_release.sh

# Or manual
pip3 install -r requirements-build.txt
python3 build_release.py
```

## What Gets Built

The build process creates a `release/` folder containing:

```
release/
├── basic/                  # Uncompiled version
│   ├── basic.py           # Main launcher script
│   ├── basic/             # BASIC interpreter modules
│   └── disassembler/      # Disassembler modules
├── basic-bns/             # Compiled version
│   └── basic-bns          # Compiled executable (basic-bns.exe on Windows)
├── examples/              # BASIC program examples (.bas files)
├── bt-examples/           # Additional examples
├── bns_game_pack/         # Compiled binary games (.bas.bin files)
├── docs/                  # Documentation
├── README.md              # Original project README
├── LICENSE                # License file
└── README_RELEASE.md      # Release-specific instructions
```

## Usage After Build

### Uncompiled Version (basic)
- **Development and learning**: Source code is visible and editable
- **Interactive mode**: Supports `-i` flag for interactive programming
- **File format**: Runs `.bas` text files

```bash
# Run a program
python release/basic/basic.py examples/hello.bas

# Interactive mode
python release/basic/basic.py -i

# Interactive with file
python release/basic/basic.py -i examples/hello.bas
```

### Compiled Version (basic-bns)
- **Production deployment**: No Python installation required
- **Source protection**: Users cannot see the source code
- **Security**: No interactive mode to prevent code inspection
- **File format**: Runs `.bas.bin` compiled binary files

```bash
# Run a compiled program
./release/basic-bns/basic-bns bns_game_pack/game.bas.bin

# On Windows
release\basic-bns\basic-bns.exe bns_game_pack\game.bas.bin
```

## Build Requirements

- Python 3.10 or later
- PyInstaller (automatically installed by build scripts)
- pygame and numpy (for BASIC interpreter functionality)

All requirements are listed in `requirements-build.txt`.

## Customizing the Build

### Modifying the Build Script

Edit `build_release.py` to customize:

- **Release directory name**: Change `RELEASE_DIR` variable
- **Additional files**: Modify `copy_examples_and_docs()` function
- **Executable options**: Edit the PyInstaller spec in `build_basic_bns_executable()`

### PyInstaller Options

The build uses these PyInstaller settings:
- **One-file executable**: Everything bundled into a single file
- **Console application**: Shows command-line output
- **UPX compression**: Reduces executable size
- **Hidden imports**: Includes all necessary BASIC interpreter modules

### Platform-Specific Notes

#### Windows
- Creates `basic-bns.exe`
- Batch files use Windows line endings
- PowerShell script available for advanced users

#### Linux/macOS
- Creates `basic-bns` (no extension)
- Shell script sets executable permissions
- May require `chmod +x` on the final executable

## Troubleshooting

### PyInstaller Issues
- **Import errors**: Add missing modules to `hiddenimports` in build script
- **Large executable size**: Remove unnecessary dependencies
- **Runtime errors**: Test the executable in a clean environment

### Path Issues
- **Module not found**: Ensure all source paths in build script are correct
- **Permission denied**: Check file permissions, especially on Unix systems

### Dependencies
- **Missing requirements**: Run `pip install -r requirements-build.txt`
- **Version conflicts**: Use a virtual environment for building

## Automated Builds

### GitHub Actions
The included `.github/workflows/build.yml` automatically builds releases for:
- Ubuntu (Linux)
- Windows
- macOS

Triggered by:
- Git tags starting with 'v' (e.g., `v1.0.0`)
- Manual workflow dispatch

### Local CI/CD
You can integrate the build script into your own CI/CD pipeline by calling:
```bash
python build_release.py
```

The script returns exit code 0 on success, 1 on failure.

## Distribution

After building, you can distribute:

1. **Complete package**: Entire `release/` folder
2. **Compiled only**: Just the `basic-bns/` folder for end users
3. **Source only**: Just the `basic/` folder for developers
4. **Platform-specific**: Separate packages per operating system

## Security Considerations

- **basic-bns**: Designed for secure deployment where source code must be protected
- **basic**: Intended for development and educational use where source visibility is desired
- **Binary files**: `.bas.bin` files cannot be easily reverse-engineered to original source

## Version Management

Update version numbers in:
- `pyproject.toml` (project version)
- `build_release.py` (if version is hardcoded anywhere)
- Git tags for automated builds