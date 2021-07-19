import 'package:dio/dio.dart';
import 'package:shark/models/constant.dart';
import 'package:shark/models/remote_config.dart';

class ApiClient {
  ApiClient._();

  static ApiClient instance = ApiClient._();

  factory ApiClient() => instance;

  late final Dio _dio;

  /// init api client
  Future<void> init(String baseUrl, String deviceInfo,
      {RemoteConfig? remoteConfig, List<Interceptor>? interceptors}) async {
    remoteConfig ??= _defaultConfig;
    final headers = remoteConfig.headers ?? {};
    _insertSharkHeader(
      headers..putIfAbsent('deviceInfo', () => deviceInfo),
    );

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: headers,
        queryParameters: remoteConfig.queryParams,
        sendTimeout: remoteConfig.timeout ?? 20000,
        receiveTimeout: remoteConfig.timeout ?? 20000,
        connectTimeout: remoteConfig.timeout ?? 20000,
      ),
    );

    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  /// http get method
  Future<Response> get(String path,
          {Map<String, dynamic>? params, Options? options}) =>
      _dio.get(path, queryParameters: params, options: options);

  /// http post method
  Future<Response> post(String path,
      {Map<String, dynamic>? params, Options? options}) =>
      _dio.post(path, queryParameters: params, options: options);

  /// push shark default headers to api client
  void _insertSharkHeader(Map headers) {
    headers.addAll(sharkRemoteHeaders);
  }

  RemoteConfig get _defaultConfig =>
      RemoteConfig(timeout: timeout, queryParams: {}, headers: {});
}
