import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shark/models/enum.dart';
import 'package:shark/views/shark_bridge.dart';
import 'package:shark/views/shark_controller.dart';
import 'package:shark/views/shark_widget_mixin.dart';

/// Entry point for user to create shark widget
/// use [SharkController] to interact with UI components
class SharkWidget extends StatefulWidget {
  const SharkWidget(
      {required this.controller,
      this.clickEvent,
      this.initWidget,
      this.loadingWidget,
      this.errorWidget,
      Key? key})
      : super(key: key);

  final SharkController controller;
  final ClickEvent? clickEvent;
  final Widget? initWidget;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  @override
  _SharkWidgetState createState() => _SharkWidgetState();
}

class _SharkWidgetState extends State<SharkWidget> with SharkWidgetMixin {
  late final SharkController _controller;
  late final _initView;
  late final _loadingView;
  late final _errorView;

  @override
  void initState() {
    _controller = widget.controller;

    _initView = widget.initWidget ?? SizedBox();
    _loadingView = widget.loadingWidget ?? _defaultLoadingView;
    _errorView = widget.errorWidget ?? _defaultErrorView;
    super.initState();
  }

  @override
  void requestWidget() {
    // request the UI asynchronous here
    _controller.get();
  }

  Widget get _defaultErrorView => Center(
        child: Text('Something went wrong'),
      );

  Widget get _defaultLoadingView => Center(
        child: CircularProgressIndicator.adaptive(),
      );

  bool _isWidgetSuccess(SharkWidgetState state) =>
      state == SharkWidgetState.success;

  bool _isFetchingWidget(SharkWidgetState state) =>
      state == SharkWidgetState.loading;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.getStateInStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SharkWidgetState state = snapshot.data as SharkWidgetState;
          if (_isWidgetSuccess(state)) {
            return _SharkWidgetBuilder(
              jsonString: _controller.value!,
              clickEvent: widget.clickEvent,
            );
          } else if (_isFetchingWidget(state)) {
            return _loadingView;
          } else {
            return _errorView;
          }
        }
        return _initView;
      },
    );
  }
}

class _SharkWidgetBuilder extends StatelessWidget {
  final Map<String, dynamic> jsonString;
  final ClickEvent? clickEvent;

  const _SharkWidgetBuilder(
      {required this.jsonString, this.clickEvent, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicWidgetBuilder.buildFromMap(
          jsonString,
          context,
          WidgetClickListener(clickEvent),
        ) ??
        SizedBox();
  }
}

class WidgetClickListener extends ClickListener {
  final ClickEvent? _clickEvent;

  WidgetClickListener(this._clickEvent);

  @override
  void onClicked(String? event) {
    if (_clickEvent != null) _clickEvent!(event);
  }
}
