
---

### 2. `remote_mongodump.sh`

```bash
#!/bin/bash

# MongoDB connection details
MONGO_HOST=""       # Replace with MongoDB host IP or hostname
MONGO_PORT=27017   # Replace with MongoDB port if different
MONGO_USER="mongo_user"      # MongoDB username
MONGO_PASS=""                # MongoDB password
AUTH_DB="admin"              # Authentication database (usually 'admin')

# Optional: dump specific DB only, leave empty to dump all
TARGET_DB=""

# Dump output directory on the local machine
DUMP_BASE_DIR="/mnt"
DATE_STR=$(date +%F)
DUMP_DIR="${DUMP_BASE_DIR}/mongodump-${DATE_STR}"

# Create dump directory if it doesn't exist
mkdir -p "$DUMP_DIR"

echo "Starting mongodump from remote MongoDB at $MONGO_HOST..."

# Build mongodump command
if [ -z "$TARGET_DB" ]; then
  CMD="mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase $AUTH_DB --out $DUMP_DIR"
else
  CMD="mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS --authenticationDatabase $AUTH_DB --db $TARGET_DB --out $DUMP_DIR"
fi

# Run mongodump
eval $CMD

if [ $? -eq 0 ]; then
  echo "mongodump completed successfully!"
else
  echo "mongodump failed!"
  exit 1
fi

# Compress the dump directory
tar -czf "${DUMP_DIR}.tar.gz" -C "$DUMP_BASE_DIR" "mongodump-${DATE_STR}"
echo "Dump compressed to ${DUMP_DIR}.tar.gz"
