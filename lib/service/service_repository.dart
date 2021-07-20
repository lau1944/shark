import 'package:dio/dio.dart';
import 'package:shark/models/result.dart';

/// Abstraction layer to communicate with [ApiClient]
abstract class ServiceRepository {

  Future<Result> get(String path, {Map<String, dynamic>? params, Options? options});
}
