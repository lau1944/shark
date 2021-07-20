
import 'package:flutter/cupertino.dart';

/// Provide request UI component function for [SharkWidget]
mixin SharkWidgetMixin<T extends StatefulWidget> on State<T> {

  @override
  void initState() {
    requestWidget();
    super.initState();
  }

  /// Request UI method
  void requestWidget();

}