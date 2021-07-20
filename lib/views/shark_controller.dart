import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shark/core/share_error.dart';
import 'package:shark/core/shark_core.dart';
import 'package:shark/models/enum.dart';
import 'package:shark/models/remote_config.dart';
import 'package:shark/models/result.dart';
import 'package:shark/service/api_client.dart';
import 'package:shark/service/service_repository.dart';
import 'package:shark/service/widget_repository.dart';

/// Controller for Shark Widget UI, in order to control current widget
class SharkController extends ChangeNotifier {
  /// path of your widget request host
  ///
  /// sample:
  /// path = '/login'
  /// your request url would become -> '$hostUrl + /login'
  final String path;

  /// Request network headers, will merge to [ApiClient] headers
  final Map<String, dynamic>? headers;

  /// Request network params
  final Map<String, dynamic>? queryParams;

  /// request json result
  Map<String, dynamic>? _resultJson;

  /// Remote data source
  ServiceRepository? _repository;

  /// Current request status
  SharkWidgetState _state = SharkWidgetState.init;

  late final StreamController<SharkWidgetState> _streamController;

  SharkController({required this.path, this.headers, this.queryParams}) {
    _streamController = StreamController();
  }

  /// Get current result value
  /// Only if [_state == SharkWidgetState.success] would return a not null value
  Map<String, dynamic>? get value => _resultJson;

  /// Get current widget request state
  SharkWidgetState get state => _state;

  /// Fetch the network data on url: $hostUrl + path
  Future<void> get() async {
    // update state to loading
    _updateState(SharkWidgetState.loading);
    assert(Shark.isInitialized);

    final repository = _serviceRepository;
    // fetch ui here
    final result = await repository.get(
      path,
      params: queryParams,
      options: Options(headers: headers),
    );

    if (result is Success) {
      _resultJson = result.data;
      _updateState(SharkWidgetState.success);
    }

    else if (result is Error) {
      SharkReport.report(result.exception, result.message);
      _updateState(SharkWidgetState.error);
    }
  }

  /// Get current state in stream
  Stream<SharkWidgetState> getStateInStream() => _streamController.stream;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  /// Service repository provider function
  ServiceRepository get _serviceRepository => _repository ?? WidgetRepository();

  /// update current widget state
  void _updateState(SharkWidgetState newState) {
    _state = newState;
    _streamController.add(newState);
  }
}