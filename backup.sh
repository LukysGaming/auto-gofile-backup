#!/bin/bash

BACKUP_DIR="/path_of_your_backed_up_folder/" # Folder to be backed up
BACKUP_NAME="type_whatever_$(date +%Y-%m-%d_%H-%M-%S).zip" #backup name
API_URL="https://upload.gofile.io/uploadfile"  # The upload URL
FOLDER_API_URL="https://api.gofile.io/contents/createFolder"
TMP_DIR="/tmp"
UPLOAD_FILE="${TMP_DIR}/${BACKUP_NAME}"

# replace YOUR_API_TOKEN with your actual token
API_TOKEN="XXX"

# replace it with your actual parent folder ID (root)
PARENT_FOLDER_ID="XXX"

# Create a folder based on the current date
FOLDER_NAME=$(date +%Y-%m-%d)

# create the folder
create_folder_response=$(curl -s -X POST "$FOLDER_API_URL" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"parentFolderId\": \"$PARENT_FOLDER_ID\", \"folderName\": \"$FOLDER_NAME\"}")

# check the folder creation
folder_status=$(echo "$create_folder_response" | jq -r '.status')

if [ "$folder_status" != "ok" ]; then
    echo "folder creation failed"
    exit 1
fi

# folder ID from the response
folder_id=$(echo "$create_folder_response" | jq -r '.data.id')

if [ -z "$folder_id" ]; then
    echo "couldn't retrieve the folder ID."
    exit 1
fi

# create a backup by zipping the directory
zip -r "${UPLOAD_FILE}" "${BACKUP_DIR}"

# upload the backup to the folder
response=$(curl -s -F "file=@${UPLOAD_FILE}" -F "folderId=${folder_id}" \
  -H "Authorization: Bearer ${API_TOKEN}" "$API_URL")

# response from the upload API
status=$(echo "$response" | jq -r '.status')

if [ "$status" == "ok" ]; then
    download_url=$(echo "$response" | jq -r '.data.downloadPage')
    echo "Backup uploaded successfully! download it from: $download_url"
else
    echo "backup upload failed."
fi

# Cleaning up the temporary zip file
rm -f "${UPLOAD_FILE}"

echo "Backup completed."
