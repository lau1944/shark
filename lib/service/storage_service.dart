
import 'package:shark/models/enum.dart';
import 'package:shark/service/hive_service.dart';

/// Storage service for caching purposes
/// in order to access storage service, See [CacheManager]
/// * Storage data format would all be in Map
abstract class StorageService {

  /// Pattern to get concrete storage service
  static getService(DatabaseType type) => <DatabaseType, StorageService>{
    DatabaseType.hive: HiveService()
  }[type];

  /// Disk initialization
  Future<void> init();

  /// Get data from disk
  Future get(String key);

  /// insert data to disk
  Future put(String key, dynamic data);

  /// delete data from disk
  Future delete(String key);

  /// Get Db size
  int getSize();

}