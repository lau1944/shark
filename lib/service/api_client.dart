import 'package:dio/dio.dart';
import 'package:shark/models/constant.dart';
import 'package:shark/models/remote_config.dart';

class ApiClient {
  ApiClient._();

  static ApiClient instance = ApiClient._();

  factory ApiClient() => instance;

  late final Dio _dio;

  Future<void> init(String baseUrl,
      {RemoteConfig? remoteConfig, List<Interceptor>? interceptors}) async {
    _dio = Dio();
  }

  RemoteConfig get _defaultConfig => RemoteConfig(
        timeout: timeout,
      );
}
