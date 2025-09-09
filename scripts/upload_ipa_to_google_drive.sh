#!/bin/bash

set -e 

IPA_NAME_FILE="build/ios/ipa/ipa_name.txt"
IPA_DIR="build/ios/ipa"

if [ ! -f "$IPA_NAME_FILE" ]; then
  echo "❌ Error: $IPA_NAME_FILE not found"
  exit 1
fi

IPA_NAME=$(<"$IPA_NAME_FILE")
IPA_PATH="${IPA_DIR}/${IPA_NAME}"

echo "📦 IPA Name: ${IPA_NAME}"

if [ ! -f "$IPA_PATH" ]; then
  echo "❌ Error: IPA file not found: $IPA_PATH"
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

FILE_SIZE=$(wc -c < "$IPA_PATH" | tr -d ' ')

UPLOAD_URL=$(curl --silent --location -X POST "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "X-Upload-Content-Type: application/octet-stream" \
  --header "X-Upload-Content-Length: $FILE_SIZE" \
  --header "Content-Type: application/json" \
  --data "{\"name\": \"$IPA_NAME\", \"parents\": [\"${GOOGLE_DRIVE_FOLDER_ID}\"]}" \
  --dump-header - | grep -i "Location:" | sed -E 's/Location: (.*)/\1/' | tr -d '\r')

if [ -z "$UPLOAD_URL" ]; then
  echo "❌ Error: Failed to get resumable upload URL!"
  exit 1
fi

echo "🚀 Uploading IPA..."

UPLOAD_RESPONSE=$(curl --silent --location -X PUT "$UPLOAD_URL" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/octet-stream" \
  --header "Content-Length: $FILE_SIZE" \
  --data-binary @"$IPA_PATH")

FILE_ID=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"id": "\([^"]*\)".*/\1/p')

if [ -z "$FILE_ID" ] || [ "$FILE_ID" == "null" ]; then
    echo "❌ Error: Failed to upload IPA to Google Drive!";
    exit 1;
fi

echo "🔓 Making IPA publicly accessible..."
curl --silent --location -X POST "https://www.googleapis.com/drive/v3/files/$FILE_ID/permissions" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"role": "reader", "type": "anyone"}'

echo "✅ IPA is now publicly accessible!"

GDRIVE_LINK="https://drive.google.com/file/d/$FILE_ID/view?usp=sharing"

echo "🔗 Google Drive Link => $GDRIVE_LINK"