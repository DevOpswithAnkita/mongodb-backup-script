#!/bin/bash

# MongoDB connection details
MONGO_HOST="<MONGO_HOST>"       # Replace with your MongoDB host IP or hostname
MONGO_PORT=27019                # Replace with your MongoDB port if different
MONGO_USER="<MONGO_USER>"       # MongoDB username
MONGO_PASS="<MONGO_PASS>"       # MongoDB password
AUTH_DB="admin"                 # Authentication database
BACKUP_DIR="/mnt/mongodump-2025-05-19/"  # Path to your backup folder
LOG_FILE="/mnt/restore_mongo_$(date +%F).log"

# Start the restore process in the background and save logs
echo "Starting mongorestore... Logs are being written to $LOG_FILE"
mongorestore --host "$MONGO_HOST" --port "$MONGO_PORT" \
    --username "$MONGO_USER" --password "$MONGO_PASS" \
    --authenticationDatabase "$AUTH_DB" \
    --dir "$BACKUP_DIR" \
    --db patent_data > "$LOG_FILE" 2>&1 &

echo "mongorestore is running in the background. Check logs at $LOG_FILE."
