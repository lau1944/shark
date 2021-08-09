import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shark/src/core/share_error.dart';
import 'package:shark/src/models/constant.dart';
import 'package:shark/src/models/enum.dart';
import 'package:shark/src/models/result.dart';
import 'package:shark/src/service/service_repository.dart';
import 'package:shark/src/service/widget_repository.dart';
import 'package:shark/src/views/default_shark_route.dart';
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

  /// current widget context
  /// current context object must be under Navigator.
  late final BuildContext context;

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
  SharkController.fromUrl(this.context, this._path,
      {this.queryParams,
      Map<String, dynamic>? header,
      this.handleClickEvent = true}) {
    _headers = header ?? {};
    _streamController.add(_state);
    _isLocalSource = false;
  }

  /// Apply widget from local source
  SharkController.fromLocal(
      {required this.source,
      required this.context,
      this.handleClickEvent = true}) {
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
  /// * please note that this method would not create a new route, it would just change UI from current page
  Future<void> redirect({required String path}) async {
    _path = path;
    return await get();
  }

  /// refresh current page corresponds to the current path
  Future<void> refresh() async {
    if (_resultJson == null)
      throwSharkError(
          message:
              'Should wait for previous result before any refresh operation');

    return await get();
  }

  /// Parse click event
  void parseEvent(String? event) {
    if (!handleClickEvent) return;

    if (event != null && event.isNotEmpty) {
      final routeMeta = _parseEvent(event);
      _doRouteAction(routeMeta!.type, routeMeta.path, routeMeta.arguments);
    }
  }

  /// Add custom parser to [SharkWidget]
  void addParse(SharkParser parser) {
    DynamicWidgetBuilder.addParser(parser);
  }

  /// Parse click action, all the path would add a '/' prefix
  void _doRouteAction(RouteType type, String path,
      [Map<String, String>? arguments]) {
    if (type == RouteType.route) {
      _openNewPage('/$path', args: arguments);
    } else if (type == RouteType.pop) {
      _pop(args: arguments);
    } else if (type == RouteType.redirect) {
      redirect(path: '/$path');
    } else if (type == RouteType.link) {
      _openUrl(path);
    }
  }

  /// Pop current route
  void _pop({Map<String, String>? args}) {
    Navigator.pop(context, args);
  }

  /// Push a new route to [Navigator]
  /// ** Please remember to specify [path] on your route map
  /// If not, navigator would throw an error
  /// then SharkController would try to navigator to a new default shark widget with following path
  void _openNewPage(String path, {Map<String, String>? args}) {
    try {
      Navigator.pushNamed(context, path, arguments: args);
    } catch (e) {
      Navigator.push(
        context,
        defaultSharkRoute(path, args),
      );
    }
  }

  /// open url on a browser
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

    throw SharkError('Unsupported data format had received');
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

/// Parse current event to [_RouteMeta] object
_RouteMeta? _parseEvent(String event) {
  try {
    final schema = _validatePrefix(event);
    if (schema.isNotEmpty) {
      if (routeTypeMap.containsKey(schema)) {
        final content = event.replaceFirst(schema, '');
        final args = event.substring(event.indexOf('?') + 1);
        return _RouteMeta(
          routeTypeMap[schema]!,
          content,
          _parseArguments(args),
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

/// Parse arguments into Map object
Map<String, String>? _parseArguments(String? args) {
  if (args == null || args.isEmpty) return null;

  final argValue = <String, String>{};
  List<String> arg = args.split('&');
  for (final e in arg) {
    List<String> pair = e.split('=');
    if (pair.length == 2) {
      argValue[pair[0]] = pair[1];
    }
  }
  return argValue;
}

/// Validate upcoming click event with their prefix
/// If the action does not satisfy routing action, will return empty string
String _validatePrefix(String event) {
  if (event.startsWith(ROUTE_SCHEMA)) {
    return ROUTE_SCHEMA;
  } else if (event.startsWith(LINK_SCHEMA)) {
    return LINK_SCHEMA;
  } else if (event.startsWith(REDIRECT_SCHEMA)) {
    return REDIRECT_SCHEMA;
  } else if (event.startsWith(POP_SCHEMA)) {
    return POP_SCHEMA;
  }

  return '';
}

class _RouteMeta {
  final RouteType type;
  final String path;

  /// for now, only support argument type in string
  final Map<String, String>? arguments;

  _RouteMeta(this.type, this.path, [this.arguments]);
}
