import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shark/core/share_error.dart';
import 'package:shark/service/storage_service.dart';

const String HIVE_STORAGE_PATH = 'shark_widget_cache';
const String HIVE_WIDGET_BOX_NAME = 'shark_box';

/// Implementation of storage service
/// Using [Hive] (https://docs.hivedb.dev/#/) package to store data
class HiveService extends StorageService {
  Box? _storageBox;

  @override
  Future<void> init() async {
    final dir = 'Shark';
    Hive.init('$dir/$HIVE_STORAGE_PATH');
    await _openBox();
  }

  Future<void> _openBox() async {
    _storageBox = await Hive.openBox(HIVE_WIDGET_BOX_NAME);
  }

  @override
  Future get(key) async {
    if (_storageBox == null) _throwUnInitError();

    return await _storageBox!.get(key);
  }

  @override
  Future put(key, data) async {
    if (_storageBox == null) _throwUnInitError();

    return await _storageBox!.put(key, data);
  }

  @override
  Future delete(String key) async {
    if (_storageBox == null) _throwUnInitError();

    return await _storageBox!.delete(key);
  }

  @override
  int getSize() {
    if (_storageBox == null) _throwUnInitError();

    return _storageBox!.length;
  }

  Future<void> deleteLastOf(int count) async {
    if (_storageBox == null) _throwUnInitError();

    final size = getSize();
    for (int i = size - count; i < size; ++i) {
      await _storageBox!.deleteAt(i);
    }
  }

  Future<void> deleteFirstOf(int count) async {
    if (_storageBox == null) _throwUnInitError();

    if (count > getSize())
      throw SharkError('Exceeded number should not bigger than the db size');

    for (int i = 0; i < count; ++i) {
      await _storageBox!.deleteAt(i);
    }
  }

  /// Iterate all the elements inside current storage with processing function
  void forEach(void transverse(key, value)) {
    assert(_storageBox != null);

    _storageBox!.toMap().forEach(transverse);
  }

  void _throwUnInitError() {
    throw SharkError('Please call init() method before starting to use');
  }
}
