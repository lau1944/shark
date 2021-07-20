
import 'package:dynamic_widget/dynamic_widget.dart';

/// Abstraction layer of dynamic_widget and shark
/// in order to create communication using shark
///
/// Base parser class (extend this class to create custom parser)
abstract class SharkParser extends WidgetParser {}

/// On click event callback
typedef void ClickEvent(String event);
