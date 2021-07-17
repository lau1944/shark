import 'package:dio/dio.dart';

/// network client configuration
class RemoteConfig {
  final int? timeout;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParams;
  final ResponseType responseType = ResponseType.json;

  const RemoteConfig({
    this.timeout,
    this.headers,
    this.queryParams,
  });
}
