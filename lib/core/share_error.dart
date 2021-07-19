
import 'dart:async';

typedef void ShareErrorFunction(error, String? message);

ShareErrorFunction get onError => (err, message) {
  print(err.toString());
  throw SharkError(message ?? err.toString());
};

class SharkReport {

  static List<ShareErrorFunction> _errorReports = [onError];

  static addErrorReport(ShareErrorFunction errorFunction) {
    _errorReports.add(errorFunction);
  }

  static report(err, [message]) {
    Future.microtask(() {
      _errorReports.forEach((e) {
        e(err, message);
      });
    });
  }
}

class SharkError extends Error {
  /// message of the error
  final String message;
  SharkError(this.message);
  
  @override
  String toString() {
    return 'SharkError: $message';
  }
}