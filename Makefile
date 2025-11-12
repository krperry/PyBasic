# Makefile for PyBasic Release Builder

.PHONY: all clean build install test help

# Default target
all: build

# Build the release
build:
	@echo "Building PyBasic release..."
	@chmod +x build_release.sh
	@./build_release.sh

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@rm -rf release/
	@rm -rf build/
	@rm -rf dist/
	@rm -f *.spec
	@echo "Clean complete"

# Install to system (requires sudo)
install: build
	@echo "Installing PyBasic to system..."
	@cd release && sudo ./install.sh

# Install to user directory
install-user: build
	@echo "Installing PyBasic to user directory..."
	@mkdir -p ~/.local/bin
	@cd release && ./install.sh ~/.local/bin
	@echo "Add ~/.local/bin to your PATH if not already done"

# Test the build
test: build
	@echo "Testing PyBasic build..."
	@if [ -f release/basic/basic ]; then \
		echo "Testing basic script..."; \
		release/basic/basic --help; \
	fi
	@if [ -f release/basic-bns/basic-bns ]; then \
		echo "Testing basic-bns executable..."; \
		release/basic-bns/basic-bns --help; \
	fi
	@echo "Test complete"

# Create a distributable package
package: build
	@echo "Creating distributable package..."
	@tar -czf pybasic-release-$$(uname -s)-$$(uname -m).tar.gz -C release .
	@echo "Package created: pybasic-release-$$(uname -s)-$$(uname -m).tar.gz"

# Show help
help:
	@echo "PyBasic Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  build         - Build the release (default)"
	@echo "  clean         - Clean build artifacts"
	@echo "  install       - Install to system (/usr/local/bin, requires sudo)"
	@echo "  install-user  - Install to user directory (~/.local/bin)"
	@echo "  test          - Test the built executables"
	@echo "  package       - Create a distributable tar.gz package"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make            # Build the release"
	@echo "  make clean      # Clean everything"
	@echo "  make install    # Install system-wide"
	@echo "  make package    # Create distribution package"