#!/bin/bash

set -e 

EXPORT_PLIST=${EXPORT_PLIST:-"ios/export_options/DevExportOptions.plist"}

export IPA_NAME="release-$(date +%d-%m-%Y-%H-%M-%S).ipa"

echo "🚀 Cleaning Flutter project..."
flutter clean

echo "📦 Fetching Flutter dependencies..."
flutter pub get

echo "📦 Installing CocoaPods..."
cd ios
pod install
cd ..

echo "🛠 Building IPA with export plist: $EXPORT_PLIST"
flutter build ipa --release --export-options-plist="$EXPORT_PLIST"

GENERATED_IPA_FILE=$(find build/ios/ipa -maxdepth 1 -name "*.ipa" | head -n 1)

NEW_IPA_PATH="build/ios/ipa/$IPA_NAME"

if [ -f "$GENERATED_IPA_FILE" ]; then
    mv "$GENERATED_IPA_FILE" "$NEW_IPA_PATH"
    echo "✅ IPA built successfully and renamed to $IPA_NAME"
    
    echo "$IPA_NAME" > build/ios/ipa/ipa_name.txt
else
    echo "❌ Error: IPA file not found after build! Expected to find it in build/ios/ipa/" >&2
    echo "$IPA_NAME" > build/ios/ipa/ipa_name.txt

    exit 1
fi