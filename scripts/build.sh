#!/bin/bash
set -e

echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Building web app..."
flutter clean
flutter pub get
flutter build web --release --no-tree-shake-icons
