import 'package:path_provider/path_provider.dart';
import 'package:shark/models/cache_strategy.dart';
import 'package:shark/models/constant.dart';
import 'package:shark/service/hive_service.dart';
import 'package:shark/service/storage_service.dart';
import 'package:shark/utils/date_util.dart';

/// Use this to manage cache in dart framework
/// It decode [CacheStrategy] and uses strategy pattern to interact with [StorageService]
class CacheManager {

  /// Current Storage service
  static late final StorageService _storageService;

  static Future<void> init({required CacheStrategy strategy}) async {
    _storageService = StorageService.getService(strategy.databaseType);
    await _storageService.init(strategy.path);

    _validateCache(strategy);
  }

  static Future<void> push(String key, dynamic data) async {
    return await _storageService.put(key, data);
  }

  static Future get(String key) async {
    return await _storageService.get(key);
  }

  /// Validate current disk info in order to fit the cache policy
  static void _validateCache(CacheStrategy strategy) {
    final dbSize = _storageService.getSize();

    // validate size
    if (dbSize > strategy.maxCacheCount) {
      _removeFirstOf(dbSize - strategy.maxCacheCount);
    }

    // validate date
    _validateDate(strategy.maxDuration);
  }

  /// Validate if date has exceeded maxDuration
  static Future<void> _validateDate(Duration maxDuration) async {
    // the element key which exceed the duration
    List<String> garbageKey = [];
    // find all the element fits the requirement
    if (_storageService is HiveService) {
      (_storageService as HiveService).forEach((key, value) {
        if (value[DB_DATE_KEY] != null &&
            isDateExpired(value[DB_DATE_KEY], maxDuration.inMilliseconds)) {
          garbageKey.add(key);
        }
      });
    }
    // delete garbage
    for (final key in garbageKey) {
      await _storageService.delete(key);
    }
  }

  /// Remove the last couple of exceeded data
  /*static Future<void> _removeLastOf(int excludeCount) async {
    if (_storageService is HiveService) {
      await (_storageService as HiveService).deleteLastOf(excludeCount);
    }
  }*/

  /// Remove the least unused exceeded data
  static Future<void> _removeFirstOf(int excludeCount) async {
    if (_storageService is HiveService) {
      await (_storageService as HiveService).deleteFirstOf(excludeCount);
    }
  }
}
