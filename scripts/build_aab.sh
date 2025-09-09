#!/bin/bash

set -e  

export AAB_NAME="release-$(date +%d-%m-%Y-%H-%M-%S).aab"

echo "🚀 Cleaning project..."
flutter clean

echo "📦 Fetching dependencies..."
flutter pub get --offline


echo "🛠 Building release AAB..."
flutter build appbundle --release --no-shrink

AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
NEW_AAB_PATH="build/app/outputs/bundle/release/$AAB_NAME"

if [ -f "$AAB_PATH" ]; then
    mv "$AAB_PATH" "$NEW_AAB_PATH"
    echo "✅ AAB built successfully: $AAB_NAME"
    echo "$AAB_NAME" > build/app/outputs/bundle/release/aab_name.txt
else
    echo "❌ Error: AAB not found!"
    exit 1
fi
