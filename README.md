# MongoDB Backup & Restore Tools

Simple scripts for backing up and restoring MongoDB databases across Windows, Linux, and macOS.

## Quick Start

1. **Download** the scripts
2. **Edit** the connection settings
3. **Run** the backup or restore command

## Installation

### Prerequisites

- MongoDB Tools (mongodump & mongorestore)
- Bash environment (Linux/macOS) or Git Bash/WSL (Windows)

### Install MongoDB Tools

#### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install -y mongodb-org-tools
```

#### macOS

```bash
brew tap mongodb/brew
brew install mongodb-database-tools
```

#### Windows

1. Download MongoDB Database Tools from [MongoDB Download Center](https://www.mongodb.com/try/download/database-tools)
2. Install the package
3. Add the bin directory to your PATH

## Backup Script

Save as `mongodump.sh`:

```bash
#!/bin/bash
# MongoDB connection details
MONGO_HOST=""       # Replace with MongoDB host IP or hostname
MONGO_PORT=27017    # Replace with MongoDB port if different
MONGO_USER="mongo_user"      # MongoDB username
MONGO_PASS=""                # MongoDB password
AUTH_DB="admin"              # Authentication database (usually 'admin')
# Optional: dump specific DB only, leave empty to dump all
TARGET_DB=""
# Dump output directory on the local machine
DUMP_BASE_DIR="/mnt"         # Linux/macOS path
# For Windows, use something like:
# DUMP_BASE_DIR="C:/MongoDB_Backups"

DATE_STR=$(date +%F)
DUMP_DIR="${DUMP_BASE_DIR}/mongodump-${DATE_STR}"

# Create dump directory if it doesn't exist
mkdir -p "$DUMP_DIR"

echo "Starting mongodump from MongoDB at $MONGO_HOST..."

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
```

## Restore Script

Save as `mongorestore.sh`:

```bash
#!/bin/bash
# MongoDB connection details
MONGO_HOST=""       # Replace with your MongoDB host IP or hostname
MONGO_PORT=27017    # Replace with your MongoDB port if different
MONGO_USER=""       # MongoDB username
MONGO_PASS=""       # MongoDB password
AUTH_DB="admin"     # Authentication database

# Path to your backup folder - update this to your actual backup location
BACKUP_DIR="/mnt/mongodump-2025-05-19/"  
# For Windows, use something like:
# BACKUP_DIR="C:/MongoDB_Backups/mongodump-2025-05-19/"

# Optional: restore to specific database, remove if restoring all
TARGET_DB="patent_data"

# Log file location 
LOG_FILE="/mnt/restore_mongo_$(date +%F).log"
# For Windows, use something like:
# LOG_FILE="C:/MongoDB_Backups/logs/restore_mongo_$(date +%F).log"

# Start the restore process in the background and save logs
echo "Starting mongorestore... Logs are being written to $LOG_FILE"

if [ -z "$TARGET_DB" ]; then
  mongorestore --host "$MONGO_HOST" --port "$MONGO_PORT" \
      --username "$MONGO_USER" --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      --dir "$BACKUP_DIR" > "$LOG_FILE" 2>&1 &
else
  mongorestore --host "$MONGO_HOST" --port "$MONGO_PORT" \
      --username "$MONGO_USER" --password "$MONGO_PASS" \
      --authenticationDatabase "$AUTH_DB" \
      --dir "$BACKUP_DIR" \
      --db "$TARGET_DB" > "$LOG_FILE" 2>&1 &
fi

echo "mongorestore is running in the background. Check logs at $LOG_FILE."
```

## How to Use

### Step 1: Configure Scripts

1. Open the script files in any text editor
2. Update the connection settings:
   - `MONGO_HOST`: Your MongoDB server address
   - `MONGO_PORT`: Your MongoDB port (default: 27017)
   - `MONGO_USER`: Username for authentication
   - `MONGO_PASS`: Password for authentication
3. Set the backup directory path appropriate for your OS:
   - Linux/macOS: `/path/to/backup/dir`
   - Windows: `C:/path/to/backup/dir`

### Step 2: Make Scripts Executable

#### Linux/macOS

```bash
chmod +x mongodump.sh mongorestore.sh
```

#### Windows

No special permissions needed. You'll run them with Git Bash or WSL.

### Step 3: Run the Scripts

#### Backup (All Operating Systems)

```bash
# Linux/macOS
./mongodump.sh

# Windows (Git Bash or WSL)
bash mongodump.sh
```

#### Restore (All Operating Systems)

```bash
# Linux/macOS
./mongorestore.sh

# Windows (Git Bash or WSL)
bash mongorestore.sh
```

## Common Tasks

### Backup a Specific Database

Edit `mongodump.sh` and set:

```bash
TARGET_DB="your_database_name"
```

### Restore a Specific Database

Edit `mongorestore.sh` and set:

```bash
TARGET_DB="your_database_name"
```

### Restore from a Compressed Backup

1. Extract the backup first:

```bash
# Linux/macOS
mkdir -p /path/to/extract
tar -xzf /path/to/mongodump-2025-05-19.tar.gz -C /path/to/extract

# Windows (Git Bash)
mkdir -p /c/path/to/extract
tar -xzf /c/path/to/mongodump-2025-05-19.tar.gz -C /c/path/to/extract
```

2. Update the `BACKUP_DIR` in `mongorestore.sh` to the extracted location
3. Run the restore script

## Scheduling Backups

### Linux/macOS (Cron)

```bash
# Edit crontab
crontab -e

# Add this line for daily backup at 2 AM
0 2 * * * /path/to/mongodump.sh
```

### Windows (Task Scheduler)

1. Open Task Scheduler
2. Create a Basic Task
   - Name: "MongoDB Backup"
   - Trigger: Daily at 2:00 AM
   - Action: Start a program
   - Program: `C:\Program Files\Git\bin\bash.exe`
   - Arguments: `-c "/path/to/mongodump.sh"`

## Troubleshooting

### MongoDB Connection Issues

- Check if MongoDB is running: `mongo --host <your-host> --port <your-port>`
- Verify credentials are correct
- Ensure network connectivity to MongoDB server

### Permission Issues

- Ensure scripts are executable (Linux/macOS)
- Check write permissions to backup directory

### Space Issues

- Verify sufficient disk space for backups
- Consider implementing backup rotation

## Need Help?
For more MongoDB backup and restore options, refer to the official documentation:
- [MongoDB Backup Methods](https://docs.mongodb.com/manual/core/backups/)
- [mongodump Documentation](https://docs.mongodb.com/database-tools/mongodump/)
- [mongorestore Documentation](https://docs.mongodb.com/database-tools/mongorestore/)
