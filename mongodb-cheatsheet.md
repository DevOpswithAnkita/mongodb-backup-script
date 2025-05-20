# MongoDB Cheatsheet: Useful Queries and Commands

A comprehensive collection of MongoDB commands and queries for database administrators and developers.

## Table of Contents

- [Basic Database Operations](#basic-database-operations)
- [Collection Operations](#collection-operations)
- [Query Operations](#query-operations)
- [Index Management](#index-management)
- [Database Statistics](#database-statistics)
- [User Management](#user-management)
- [Backup and Restore](#backup-and-restore)
- [Performance Analysis](#performance-analysis)
- [Collection Size Reporting](#collection-size-reporting)

## Basic Database Operations

### Show all databases

```
show dbs
```

### Show all collections in the current DB

```
show collections
```

### Get stats for current database

```
db.stats()
```

## Collection Operations

### Get collection stats (in GB)

```
db.collection_name.stats({ scale: 1024 * 1024 * 1024 })
```

### Drop a collection

```
db.collection_name.drop()
```

## Query Operations

### Find one document

```
db.collection_name.findOne()
```

### Find with filter and projection

```
db.collection_name.find({ status: "active" }, { _id: 0, name: 1, status: 1 })
```

### Count documents

```
db.collection_name.countDocuments({ status: "active" })
```

### Delete many

```
db.collection_name.deleteMany({ status: "inactive" })
```

### Update documents

```
db.collection_name.updateMany({ status: "new" }, { $set: { status: "active" } })
```

### Aggregation example (grouping)

```javascript
db.collection_name.aggregate([
  { $group: { _id: "$status", count: { $sum: 1 } } }
])
```

### Query with sorting and limit

```
db.collection_name.find().sort({ created_at: -1 }).limit(10)
```

## Index Management

### List indexes

```
db.collection_name.getIndexes()
```

### Create index

```
db.collection_name.createIndex({ field_name: 1 })
```

## Database Statistics

### Server status overview

```
db.serverStatus()
```

### List slow queries

```
db.system.profile.find({ millis: { $gt: 100 } }).sort({ millis: -1 })
```

## User Management

### Create a new user

```javascript
db.createUser({
  user: "admin_user",
  pwd: "secure_password",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWrite", db: "your_database_name" }
  ]
})
```

### Show all users

```
db.getUsers()
```

### Show roles

```
db.getRoles({ showBuiltinRoles: false })
```

### Drop a user

```
db.dropUser("admin_user")
```

### Update user password

```
db.changeUserPassword("admin_user", "new_secure_password")
```

## Backup and Restore

### Backup using mongodump

```bash
mongodump --host localhost --port 27017 --db your_db_name --out /path/to/backup/folder
```

### Backup with authentication

```bash
mongodump --uri="mongodb://username:password@localhost:27017/your_db_name" --out /path/to/backup
```

### Run mongodump in background and save logs

```bash
nohup bash remote_mongodump.sh > mongodump.log 2>&1 &
```

### Restore a backup using mongorestore

```bash
mongorestore --host localhost --port 27017 --db your_db_name /path/to/backup/your_db_name
```

### Restore with authentication

```bash
mongorestore --uri="mongodb://username:password@localhost:27017/your_db_name" /path/to/backup/your_db_name
```

## Performance Analysis

### Explain query performance

```
db.collection_name.find({ status: "active" }).explain("executionStats")
```

## Collection Size Reporting

### Collection size report for all collections (in MB)

```javascript
db.getCollectionNames().forEach(function(c) {
  var s = db[c].stats({ scale: 1024 * 1024 });
  print(c + ": " + s.size.toFixed(2) + " MB");
});
```

### Show all collections' sizes in GB

```javascript
db.getCollectionNames().forEach(function(coll) {
  var stats = db.getCollection(coll).stats({ scale: 1024 * 1024 * 1024 });
  print(coll + " - Data: " + stats.size.toFixed(2) + " GB, Storage: " + stats.storageSize.toFixed(2) + " GB, Indexes: " + stats.totalIndexSize.toFixed(2) + " GB");
});
```
