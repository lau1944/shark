import 'package:dio/dio.dart';
import 'package:shark/src/models/result.dart';

/// Abstraction layer to communicate with [ApiClient]
abstract class ServiceRepository {
  Future<Result> get(String path,
      {Map<String, dynamic>? params, Options? options});
}
