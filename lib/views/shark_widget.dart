import 'package:flutter/cupertino.dart';
import 'package:shark/models/remote_config.dart';
import 'package:shark/views/shark_controller.dart';
import 'package:shark/views/shark_widget_mixin.dart';

/// Entry widget for dynamic widget
/// use [SharkController] to interact with UI components
class SharkWidget extends StatefulWidget {
  const SharkWidget(
      {required this.controller, Key? key})
      : super(key: key);

  final SharkController controller;

  @override
  _SharkWidgetState createState() => _SharkWidgetState();
}

class _SharkWidgetState extends State<SharkWidget> with SharkWidgetMixin {

  @override
  void requestWidget() {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
