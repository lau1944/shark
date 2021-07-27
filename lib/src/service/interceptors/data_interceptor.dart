import 'package:dio/dio.dart';
import 'package:shark/src/core/cache_manager.dart';
import 'package:shark/src/core/share_error.dart';
import 'package:shark/src/models/cache_strategy.dart';
import 'package:shark/src/models/constant.dart';

/// Widget request interceptors
class DataInterceptor extends Interceptor {
  final CacheStrategy cacheStrategy;

  DataInterceptor({required this.cacheStrategy});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final key = options.uri.path;
    if (_isWidgetRequest(options.headers) && cacheStrategy.cacheAsPrimary) {
      final data = await CacheManager.get(key);
      if (data != null) {
        handler.resolve(
          Response(
            requestOptions: options,
            data: data,
          ),
        );
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final key = response.realUri.path;
    final data = response.data;
    if (!cacheStrategy.excludeKeys.contains(key)) {
      _pushInCache(key, {
        DB_DATE_KEY: DateTime.now().millisecondsSinceEpoch,
        'widget': data.toString(),
      });
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    throw SharkError('Error while fetching UI widget');
  }

  void _pushInCache(String key, Map<String, dynamic> data) {
    CacheManager.push(key, data);
  }

  /// check if current request belongs to widget request
  bool _isWidgetRequest(Map<String, dynamic> headers) =>
      headers[WIDGET_REQUEST_KEY] != null;
}
