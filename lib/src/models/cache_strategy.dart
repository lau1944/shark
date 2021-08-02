import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

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

  /// This collection is the one we don't want to store them on disk
  final List<String> excludeKeys;

  /// Use dio_cache_interceptor library,
  /// see more on [https://pub.dev/packages/dio_cache_interceptor]
  CacheStore? cacheStore;

  CacheStrategy(
      {required this.path,
      this.cacheStore,
      this.maxDuration = const Duration(days: 3),
      this.cacheAsPrimary = false,
      this.excludeKeys = const []});
}
