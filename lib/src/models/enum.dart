
/// Shark Widget request status
enum SharkWidgetState {
  success, error, loading, init
}

/// Current support storage packages
/// moor: Cache with database (Moor) Get it.
/// file: Cache with file system (no web support obviously).
/// hive: Cache using Hive package (available on all platforms) Get it.
/// mem: Volatile cache with LRU strategy.
enum DatabaseType {
  file,
  hive,
  mem,
  moor,
}