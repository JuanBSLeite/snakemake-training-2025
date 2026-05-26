#!/bin/bash

set -euo pipefail

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
	Darwin)
		case "$ARCH" in
			arm64) PLATFORM="MacOSX-arm64" ;;
			x86_64) PLATFORM="MacOSX-x86_64" ;;
			*) echo "Unsupported macOS architecture: $ARCH"; exit 1 ;;
		esac
		;;
	Linux)
		case "$ARCH" in
			x86_64) PLATFORM="Linux-x86_64" ;;
			aarch64|arm64) PLATFORM="Linux-aarch64" ;;
			*) echo "Unsupported Linux architecture: $ARCH"; exit 1 ;;
		esac
		;;
	*)
		echo "Unsupported OS: $OS"
		exit 1
		;;
esac

MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-${PLATFORM}.sh"
MINICONDA_INSTALLER="miniconda_installer.sh"
INSTALL_PREFIX="${PWD}/miniconda3"

if [ -d "$INSTALL_PREFIX" ]; then
	echo "Miniconda already exists at: $INSTALL_PREFIX"
	echo "Skipping installation."
	exit 0
fi

if command -v curl >/dev/null 2>&1; then
	curl -fsSL "$MINICONDA_URL" -o "$MINICONDA_INSTALLER"
elif command -v wget >/dev/null 2>&1; then
	wget "$MINICONDA_URL" -O "$MINICONDA_INSTALLER"
else
	echo "Neither curl nor wget is available."
	exit 1
fi

chmod +x "$MINICONDA_INSTALLER"
./"$MINICONDA_INSTALLER" -b -p "$INSTALL_PREFIX"
rm -f "$MINICONDA_INSTALLER"

echo "Miniconda installation complete at: $INSTALL_PREFIX"
echo "Use it with: $INSTALL_PREFIX/bin/conda"
