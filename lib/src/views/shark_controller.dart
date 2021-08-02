import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shark/src/core/share_error.dart';
import 'package:shark/src/models/constant.dart';
import 'package:shark/src/models/enum.dart';
import 'package:shark/src/models/result.dart';
import 'package:shark/src/service/service_repository.dart';
import 'package:shark/src/service/widget_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shark.dart';

/// Controller for Shark Widget UI, in order to control current widget
class SharkController extends ChangeNotifier {
  /// path of your widget request host
  ///
  /// sample:
  /// path = '/login'
  /// your request url would become -> '$hostUrl + /login'
  String _path = '';

  /// Request network headers, will merge to [ApiClient] headers
  Map<String, dynamic> _headers = {};

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

  /// Whether shark should handle click event or not
  /// including route, link event
  late final bool handleClickEvent;

  final StreamController<SharkWidgetState> _streamController =
      StreamController.broadcast();

  /// Apply widget resource from remote source
  SharkController.fromUrl(this._path,
      {this.queryParams,
      Map<String, dynamic>? header,
      this.handleClickEvent = true}) {
    _headers = header ?? {};
    _streamController.add(_state);
    _isLocalSource = false;
  }

  /// Apply widget from local source
  SharkController.fromLocal(
      {required this.source, this.handleClickEvent = true}) {
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
        _path,
        params: queryParams,
        options: Options(headers: _headers),
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

  /// Get current state in stream
  Stream<SharkWidgetState> get stateStream =>
      _streamController.stream.asBroadcastStream();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  /// update current request header
  void updateHeader({required Map<String, dynamic> header}) {
    _headers = header;
  }

  /// update current request params
  void updateParam({required Map<String, dynamic> params}) {
    queryParams = params;
  }

  /// Update current widget path & request a new widget
  Future<void> redirect({required String path}) async {
    _path = path;
    return await get();
  }

  void parseEvent(String? event) {
    if (event != null && event.isNotEmpty) {
      final routeMeta = _parseEvent(event);
      _doRouteAction(routeMeta!.type, routeMeta.path);
    }
  }

  void _doRouteAction(RouteType type, String path) {
    if (type == RouteType.route) {
      redirect(path: '/$path');
    } else if (type == RouteType.link) {
      _openUrl(path);
    }
  }

  void _openUrl(String url) async {
    await canLaunch(url)
        ? await launch(url)
        : throwSharkError(message: 'error launching url');
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
    _headers[WIDGET_REQUEST_KEY] = 'widget_request';
  }

  /// Service repository provider function
  ServiceRepository get _serviceRepository => _repository ?? WidgetRepository();

  /// update current widget state
  void _updateState(SharkWidgetState newState) {
    _state = newState;
    _streamController.add(newState);
  }
}

_RouteMeta? _parseEvent(String event) {
  try {
    final schema = _validateEvent(event);
    if (schema.isNotEmpty) {
      if (routeTypeMap.containsKey(schema)) {
        return _RouteMeta(
          routeTypeMap[schema]!,
          event.toString().replaceFirst(schema, ''),
        );
      }
      throwSharkError(message: 'No route schema match, please check again');
    } else {
      throwSharkError(message: 'Please contain a schema on click_event field');
    }
  } catch (e) {
    SharkReport.report(e);
  }
}

/// Validate upcoming click event with their prefix
/// If the action does not satisfy routing action, will return empty string
String _validateEvent(String event) {
  if (event.startsWith(ROUTE_SCHEMA)) {
    return ROUTE_SCHEMA;
  } else if (event.startsWith(LINK_SCHEMA)) {
    return LINK_SCHEMA;
  }

  return '';
}

class _RouteMeta {
  final RouteType type;
  final String path;

  _RouteMeta(this.type, this.path);
}
