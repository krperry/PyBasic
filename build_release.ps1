# PowerShell build script for PyBasic release

Write-Host "=== PyBasic Release Builder (PowerShell) ===" -ForegroundColor Green

# Check if Python is available
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "Error: Python not found. Please install Python 3.10 or later." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Install build requirements
Write-Host "Installing build requirements..." -ForegroundColor Yellow
python -m pip install -r requirements-build.txt

# Run the build script
Write-Host "Running build script..." -ForegroundColor Yellow
python build_release.py

Write-Host ""
Write-Host "Build complete! Check the 'release' folder." -ForegroundColor Green
Read-Host "Press Enter to exit"