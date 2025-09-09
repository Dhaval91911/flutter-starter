#!/bin/bash

set -e

APK_NAME_FILE="build/app/outputs/flutter-apk/apk_name.txt"
APK_DIR="build/app/outputs/flutter-apk"

if [ ! -f "$APK_NAME_FILE" ]; then
  echo "❌ Error: $APK_NAME_FILE not found"
  exit 1
fi

APK_NAME=$(<"$APK_NAME_FILE")
APK_PATH="${APK_DIR}/${APK_NAME}"

echo "📦 APK Name: ${APK_NAME}"

if [ ! -f "$APK_PATH" ]; then
  echo "❌ Error: APK file not found: $APK_PATH"
  exit 1
fi

TOKEN_RESPONSE=$(curl --silent --location -X POST "https://oauth2.googleapis.com/token" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "client_id=${GOOGLE_CLIENT_ID}" \
  --data-urlencode "client_secret=${GOOGLE_CLIENT_SECRET}" \
  --data-urlencode "refresh_token=${GOOGLE_REFRESH_TOKEN}" \
  --data-urlencode "grant_type=refresh_token")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | sed -n 's/.*"access_token": "\([^"]*\)".*/\1/p')
if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
  echo "Error: Failed to obtain access token"
  echo "Response: $TOKEN_RESPONSE"
  exit 1
fi

if [ -z "$ACCESS_TOKEN" ]; then
  echo "❌ Error: Access token is empty. Check authentication details."
  exit 1
fi

FILE_SIZE=$(wc -c < "$APK_PATH" | tr -d ' ')

echo "🔑 Access Token: ${ACCESS_TOKEN:0:10}..."
echo "📁 Upload Folder: $GOOGLE_DRIVE_FOLDER_ID"
echo "📁Folder Size: $FILE_SIZE"

UPLOAD_URL=$(
    
    curl --silent --location -X POST "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "X-Upload-Content-Type: application/vnd.android.package-archive" \
  --header "X-Upload-Content-Length: $FILE_SIZE" \
  --header "Content-Type: application/json" \
  --data "{\"name\": \"$APK_NAME\", \"parents\": [\"${GOOGLE_DRIVE_FOLDER_ID}\"]}" \
  --dump-header - | grep -i "Location:" | sed -E 's/Location: (.*)/\1/' | tr -d '\r'
  
  )

if [ -z "$UPLOAD_URL" ] || [ "$UPLOAD_URL" == "null" ]; then
  echo "❌ Error: Failed to get resumable upload URL!"
  exit 1
fi

echo "🚀 Uploading APK..."


UPLOAD_RESPONSE=$(curl --silent --location -X PUT "$UPLOAD_URL" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/vnd.android.package-archive" \
  --header "Content-Length: $FILE_SIZE" \
  --data-binary @"$APK_PATH")


FILE_ID=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"id": "\([^"]*\)".*/\1/p')

if [ -z "$FILE_ID" ] || [ "$FILE_ID" == "null" ]; then
    echo "❌ Error: Failed to upload APK to Google Drive!";
    exit 1;
fi

echo "🔓 Making APK publicly accessible..."
curl --silent --location -X POST "https://www.googleapis.com/drive/v3/files/$FILE_ID/permissions" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"role": "reader", "type": "anyone"}'

echo "✅ APK is now publicly accessible!"

GDRIVE_LINK="https://drive.google.com/file/d/$FILE_ID/view?usp=sharing"

echo "🔗 Google Drive Link => $GDRIVE_LINK"