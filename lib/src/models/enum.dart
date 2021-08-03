/// Shark Widget request status
enum SharkWidgetState { success, error, loading, init }

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

/// Routing action type
///
/// route: prefix with 'route://', internally would call [Navigator.pushName('new_path')]
/// pop: prefix with 'pop://', internally would call [Navigator.pop()]
/// redirect: prefix with 'redirect://', redirect current page with the following path
/// link: prefix with 'link://', start the browser to open a url
enum RouteType { route, redirect, pop, link }
