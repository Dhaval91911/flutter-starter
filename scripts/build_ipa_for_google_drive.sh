#!/bin/bash

set -e
EXPORT_PLIST=${EXPORT_PLIST:-"ios/export_options/DevExportOptions.plist"}

export IPA_NAME="release-$(date +%d-%m-%Y-%H-%M-%S).ipa"

echo "🚀 Cleaning project..."
flutter clean

echo "📦 Fetching dependencies..."
flutter pub get --offline

echo "🚀 Pod installing..."
cd ios
pod install
cd ..

set +e 
echo "🔨 Building iOS archive with export plist: $EXPORT_PLIST"
flutter build ipa --release --export-options-plist="$EXPORT_PLIST"
if [ $? -ne 0 ]; then
  echo "⚠️ Warning: Archive not found! Continuing pipeline..."
fi
set -e 
echo "🔍 Checking available archives..."
ls build/ios/archive/ || echo "⚠️ Warning: Archive folder not found!"

echo "🔍 Finding the correct archive name..."
ARCHIVE_NAME=$(ls build/ios/archive/ | grep '.xcarchive' | head -n 1)

if [ -z "$ARCHIVE_NAME" ]; then
  echo "⚠️ Warning: No .xcarchive file found! Skipping IPA export..."
else
  echo "📦 Archive found: $ARCHIVE_NAME"
  echo "📦 Exporting IPA..."
  xcodebuild -exportArchive -archivePath "build/ios/archive/$ARCHIVE_NAME" -exportPath "build/ios/ipa" -exportOptionsPlist "$EXPORT_PLIST"
  echo "✅ IPA Generated Successfully!"
fi

GENERATED_IPA_FILE=$(find build/ios/ipa -maxdepth 1 -name "*.ipa" -print -quit)
NEW_IPA_PATH="build/ios/ipa/$IPA_NAME"

if [ -f "$GENERATED_IPA_FILE" ]; then
  mv "$GENERATED_IPA_FILE" "$NEW_IPA_PATH"
  echo "✅ IPA built successfully and renamed to $IPA_NAME"
  echo "$IPA_NAME" > build/ios/ipa/ipa_name.txt
else
  echo "❌ Error: IPA file not found after export! Looked in 'build/ios/ipa' for a .ipa file."
  exit 1
fi