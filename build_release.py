
#!/usr/bin/env python3
"""
Build script for PyBasic release
Creates a release folder with:
- basic (uncompiled Python script)
- basic-bns (compiled executable)
- All necessary dependencies and examples
"""

import os
import sys
import shutil
import subprocess
import tempfile
from pathlib import Path

# Configuration
RELEASE_DIR = "release"
PROJECT_ROOT = Path(__file__).parent
SRC_DIR = PROJECT_ROOT / "src"
BASIC_BNS_DIR = SRC_DIR / "basic-bns"

def clean_release_dir():
    """Clean the release directory"""
    release_path = PROJECT_ROOT / RELEASE_DIR
    if release_path.exists():
        print(f"Cleaning existing release directory: {release_path}")
        shutil.rmtree(release_path)
    
    release_path.mkdir(exist_ok=True)
    return release_path

def copy_basic_script(release_path):
    """Copy the uncompiled basic script and its dependencies in flat structure"""
    print("Copying basic script and dependencies...")
    
    # Copy basic.py directly to release root
    basic_main_src = SRC_DIR / "basic" / "basic.py"
    shutil.copy2(basic_main_src, release_path / "basic.py")
    
    # Create basic/ directory in release root (for supporting modules)
    basic_release_dir = release_path / "basic"
    basic_release_dir.mkdir(exist_ok=True)
    
    # Copy only the basic interpreter modules (exclude disassembler)
    basic_src = SRC_DIR / "basic"
    
    # List of files to copy (exclude disassembler-related files)
    basic_files = [
        "__init__.py",
        "basicparser.py",
        "basictoken.py",
        "flowsignal.py",
        "interpreter.py", 
        "lexer.py",
        "music.py",
        "program.py",
        "run.py"
    ]
    
    for filename in basic_files:
        src_file = basic_src / filename
        if src_file.exists():
            shutil.copy2(src_file, basic_release_dir / filename)
            print(f"  ✓ {filename}")
    
    # Copy __pycache__ if it exists (for performance)
    pycache_src = basic_src / "__pycache__"
    if pycache_src.exists():
        shutil.copytree(pycache_src, basic_release_dir / "__pycache__", dirs_exist_ok=True)
    
    print(f"✓ Basic script and supporting modules copied")
    return basic_release_dir

def install_pyinstaller():
    """Install PyInstaller if not available"""
    try:
        import PyInstaller
        print("✓ PyInstaller is already installed")
        return True
    except ImportError:
        print("Installing PyInstaller...")
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "pyinstaller"])
            print("✓ PyInstaller installed successfully")
            return True
        except subprocess.CalledProcessError as e:
            print(f"✗ Failed to install PyInstaller: {e}")
            return False

def build_basic_bns_executable(release_path):
    """Build the basic-bns executable using PyInstaller and place directly in release root"""
    print("Building basic-bns executable...")
    
    if not install_pyinstaller():
        return None
    
    # Build basic-bns.exe directly to release root (no subfolder)
    
    # Create a spec file for PyInstaller
    spec_content = f'''# -*- mode: python ; coding: utf-8 -*-

import sys
import os
sys.path.append(r"{SRC_DIR}")

a = Analysis(
    [r"{BASIC_BNS_DIR / 'basic-bns.py'}"],
    pathex=[r"{SRC_DIR}"],
    binaries=[],
    datas=[],
    hiddenimports=['disassembler.dc', 'disassembler.cmds', 'basic.lexer', 'basic.program', 'basic.basictoken', 'basic.flowsignal'],
    hookspath=[],
    hooksconfig={{}},
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
'''
    
    spec_file = PROJECT_ROOT / "basic-bns.spec"
    with open(spec_file, "w") as f:
        f.write(spec_content)
    
    try:
        # Build with PyInstaller directly to release root
        cmd = [
            sys.executable, "-m", "PyInstaller", 
            "--clean",
            "--distpath", str(release_path),  # Put exe directly in release root
            str(spec_file)
        ]
        
        print(f"Running: {' '.join(cmd)}")
        result = subprocess.run(cmd, cwd=PROJECT_ROOT, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✓ basic-bns.exe built successfully and placed in release root")
            # Clean up
            spec_file.unlink()
            build_dir = PROJECT_ROOT / "build"
            if build_dir.exists():
                shutil.rmtree(build_dir)
            return release_path
        else:
            print(f"✗ PyInstaller failed:")
            print(f"STDOUT: {result.stdout}")
            print(f"STDERR: {result.stderr}")
            return None
            
    except Exception as e:
        print(f"✗ Error building executable: {e}")
        return None
    finally:
        # Clean up spec file if it exists
        if spec_file.exists():
            spec_file.unlink()

def copy_examples_and_docs(release_path):
    """Copy examples and documentation to the release"""
    print("Copying examples and documentation...")
    
    # Copy examples
    examples_src = PROJECT_ROOT / "examples"
    if examples_src.exists():
        shutil.copytree(examples_src, release_path / "examples", dirs_exist_ok=True)
        print("✓ Examples copied")
    
    # Copy bt-examples
    bt_examples_src = PROJECT_ROOT / "bt-examples"
    if bt_examples_src.exists():
        shutil.copytree(bt_examples_src, release_path / "bt-examples", dirs_exist_ok=True)
        print("✓ BT Examples copied")
    
    # Copy bns_game_pack
    bns_pack_src = PROJECT_ROOT / "bns_game_pack"
    if bns_pack_src.exists():
        shutil.copytree(bns_pack_src, release_path / "bns_game_pack", dirs_exist_ok=True)
        print("✓ BNS Game Pack copied")
    
    # Copy docs
    docs_src = PROJECT_ROOT / "docs"
    if docs_src.exists():
        shutil.copytree(docs_src, release_path / "docs", dirs_exist_ok=True)
        print("✓ Documentation copied")
    
    # Copy README and LICENSE
    for file in ["README.md", "LICENSE"]:
        src_file = PROJECT_ROOT / file
        if src_file.exists():
            shutil.copy2(src_file, release_path / file)
            print(f"✓ {file} copied")

def create_release_readme(release_path):
    """Create a README for the release"""
    readme_content = '''# PyBasic Release

This release contains two versions of the PyBasic interpreter:

## basic.py - Development Version (Source Code)
- Main interpreter script (in release root)
- Source code visible and editable
- Supports interactive mode with `-i` flag
- Runs .bas files (text format)
- Supporting modules in `basic/` directory

### Usage:
```bash
# Run a BASIC program
python basic.py hello.bas

# Interactive mode
python basic.py -i

# Interactive mode with file
python basic.py -i hello.bas
```

## basic-bns.exe - Production Version (Compiled Executable)
- Standalone executable (in release root)
- Compiled executable, source code protected
- NO interactive mode (for security)
- Runs .bas.bin files (compiled binary format)

### Usage:
```bash
# Run a compiled BASIC binary program
./basic-bns.exe game.bas.bin

# On Windows:
basic-bns.exe game.bas.bin
```

## Structure
```
release/
├── basic.py              # Main interpreter (source)
├── basic-bns.exe         # Compiled executable
├── basic/                # Supporting modules for basic.py
│   ├── __init__.py
│   ├── basicparser.py
│   ├── basictoken.py
│   ├── interpreter.py
│   └── ... (other modules)
├── examples/             # Regular BASIC programs (.bas files)
├── bt-examples/          # Additional BASIC examples
├── bns_game_pack/        # Binary game files (.bas.bin format)
├── docs/                 # Language reference and documentation
├── README.md             # Project README
├── LICENSE               # License file
└── README_RELEASE.md     # This file
```

## Examples
- `examples/` - Regular BASIC programs (.bas files)
- `bt-examples/` - Additional BASIC examples
- `bns_game_pack/` - Binary game files (.bas.bin format)

## Documentation
- `docs/` - Language reference and documentation

## Requirements
- Python 3.10 or later (for basic.py)
- The compiled version (basic-bns.exe) has no Python dependencies
'''
    
    with open(release_path / "README_RELEASE.md", "w", encoding="utf-8") as f:
        f.write(readme_content)
    
    print("✓ Release README created")

def main():
    """Main build function"""
    print("=== PyBasic Release Builder ===")
    
    # Clean and create release directory
    release_path = clean_release_dir()
    print(f"Release directory: {release_path}")
    
    # Copy basic script
    basic_dir = copy_basic_script(release_path)
    if not basic_dir:
        print("✗ Failed to copy basic script")
        return 1
    
    # Build basic-bns executable
    bns_dir = build_basic_bns_executable(release_path)
    if not bns_dir:
        print("✗ Failed to build basic-bns executable")
        return 1
    
    # Copy examples and documentation
    copy_examples_and_docs(release_path)
    
    # Create release README
    create_release_readme(release_path)
    
    print("\n=== Build Complete ===")
    print(f"Release created in: {release_path}")
    print("\nContents:")
    print("- basic/          - Uncompiled Python script")
    print("- basic-bns/      - Compiled executable")
    print("- examples/       - BASIC program examples")
    print("- docs/           - Documentation")
    print("- README_RELEASE.md - Usage instructions")
    
    return 0

if __name__ == "__main__":
    sys.exit(main())