import 'package:dio/dio.dart';

/// network client configuration
/// [timeout] time out on connection
/// [headers] headers for network request
/// [interceptors] collections of interceptors for network client
/// [queryParams] params for network request
class RemoteConfig {
  final int? timeout;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParams;
  final List<Interceptor>? interceptors;
  final ResponseType responseType = ResponseType.json;

  const RemoteConfig({
    this.timeout,
    this.headers,
    this.interceptors,
    this.queryParams,
  });
}
