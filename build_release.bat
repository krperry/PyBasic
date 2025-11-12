@echo off
REM Build script for PyBasic release on Windows

echo === PyBasic Release Builder (Windows) ===

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python not found. Please install Python 3.10 or later.
    pause
    exit /b 1
)

REM Install PyInstaller if needed
echo Installing/checking PyInstaller...
python -m pip install pyinstaller

REM Run the build script
python build_release.py

echo.
echo Build complete! Check the 'release' folder.
pause