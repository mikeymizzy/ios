#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLUTTER_PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_INSTALL_DIR="${CI_WORKSPACE_PATH:-/tmp}/flutter"

if [ ! -f "$FLUTTER_PROJECT_DIR/pubspec.yaml" ]; then
    echo "Flutter project not found at $FLUTTER_PROJECT_DIR"
    echo "Xcode Cloud must clone the full Flutter project, not only the ios directory."
    exit 1
fi

if [ ! -d "$FLUTTER_INSTALL_DIR/bin" ]; then
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_INSTALL_DIR"
fi

export PATH="$FLUTTER_INSTALL_DIR/bin:$PATH"

flutter --version
flutter pub get
flutter precache --ios

cd "$FLUTTER_PROJECT_DIR/ios"
pod install --repo-update
