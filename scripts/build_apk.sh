#!/bin/bash

set -e

export APK_NAME="release-$(date +%d-%m-%Y-%H-%M-%S).apk"

echo "🚀 Cleaning project..."
flutter clean

echo "📦 Fetching dependencies..."
flutter pub get --offline

echo "🛠 Building release APK..."
flutter build apk --release --no-shrink

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
NEW_APK_PATH="build/app/outputs/flutter-apk/$APK_NAME"

if [ -f "$APK_PATH" ]; then
    mv "$APK_PATH" "$NEW_APK_PATH"
    echo "✅ APK built successfully: $APK_NAME"
    echo "$APK_NAME" > build/app/outputs/flutter-apk/apk_name.txt
else
    echo "❌ Error: APK not found!"
    exit 1
fi
