import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shark/core/share_error.dart';
import 'package:shark/core/shark_core.dart';
import 'package:shark/models/constant.dart';
import 'package:shark/models/enum.dart';
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
  String path = '';

  /// Request network headers, will merge to [ApiClient] headers
  Map<String, dynamic> headers = {};

  /// Request network params
  Map<String, dynamic>? queryParams;

  /// Local source only
  late final _isLocalSource;

  /// local source
  String? source;

  /// request json result
  Map<String, dynamic>? _resultJson;

  /// Remote data source
  ServiceRepository? _repository;

  /// Current request status
  SharkWidgetState _state = SharkWidgetState.init;

  final StreamController<SharkWidgetState> _streamController =
      StreamController();

  SharkController._();

  SharkController.fromUrl(
      {required this.path, this.queryParams, Map<String, dynamic>? header}) {
    headers = header ?? {};
    _streamController.add(_state);
    _isLocalSource = false;
  }

  SharkController.fromLocal({required this.source}) {
    _isLocalSource = true;
    _streamController.add(_state);
    _resultJson = jsonDecode(source!);
  }

  /// Get current result value
  /// Only if [_state == SharkWidgetState.success] would return a not null value
  Map<String, dynamic>? get value => _resultJson;

  /// Get current widget request state
  SharkWidgetState get state => _state;

  /// Fetch the network data on url: $hostUrl + path
  Future<void> get() async {
    _throwIfSharkNotInit();

    // update state to loading
    _updateState(SharkWidgetState.loading);
    assert(Shark.isInitialized);

    if (_isLocalSource) {
      _updateState(SharkWidgetState.success);
    } else {
      // put widget request tag to header
      // in order to identify if it's widget request
      _putWidgetRequestTag();

      final repository = _serviceRepository;
      // fetch ui here
      final result = await repository.get(
        path,
        params: queryParams,
        options: Options(headers: headers),
      );

      if (result is Success) {
        _resultJson = _deserialize(result.data);
        _updateState(SharkWidgetState.success);
      } else if (result is Error) {
        SharkReport.report(
            SharkError('Network error while fetching widget'), result.message);
        _updateState(SharkWidgetState.error);
      }
    }

    notifyListeners();
  }

  Map<String, dynamic> _deserialize(data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      return jsonDecode(data);
    }

    throw SharkError('Unsupported data format had receviced');
  }

  void _throwIfSharkNotInit() {
    if (!Shark.isInitialized) {
      throw SharkError('Please call Shark.init before any further operation');
    }
  }

  void _putWidgetRequestTag() {
    headers[WIDGET_REQUEST_KEY] = 'widget_request';
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
