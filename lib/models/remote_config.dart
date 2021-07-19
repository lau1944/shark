import 'package:dio/dio.dart';

/// network client configuration
/// [timeout] time out on connection
/// [headers] headers for network request
/// [queryParams] params for network request
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
