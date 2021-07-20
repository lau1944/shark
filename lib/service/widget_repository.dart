import 'package:dio/dio.dart';
import 'package:shark/models/result.dart';
import 'package:shark/service/api_client.dart';
import 'package:shark/service/service_repository.dart';

/// The repository for widget json fetching
class WidgetRepository extends ServiceRepository {
  final ApiClient _apiClient = ApiClient.instance;

  @override
  Future<Result> get(String path,
      {Map<String, dynamic>? params, Options? options}) {
    return _apiClient
        .get(path, params: params, options: options)
        .then(
          (value) => Result.success(data: value.data),
        )
        .catchError(
          (err) => Result.error(exception: err,
              message: 'Error Occur while fetching UI components'),
        );
  }
}
