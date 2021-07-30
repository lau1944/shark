
import 'enum.dart';

/// use for UI json data caching
class CacheStrategy {
  /// Database path
  final String path;

  /// maximum duration for cache to stay on disk
  /// default to 3 days
  final Duration maxDuration;

  /// If we should use the cache if available
  /// set True, we would see if the disk contains such element key,
  /// if it exists, will return this value (no network call would occur)
  /// default to [false]
  final bool cacheAsPrimary;

  /// Use which type to store data
  final DatabaseType databaseType;

  /// This collection is the one we don't want to store them on disk
  final List<String> excludeKeys;

  CacheStrategy(
      {required this.path,
      this.maxDuration = const Duration(days: 3),
      this.databaseType = DatabaseType.hive,
      this.cacheAsPrimary = false,
      this.excludeKeys = const []});
}
