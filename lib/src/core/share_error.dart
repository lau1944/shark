import 'dart:async';

typedef void SharkErrorFunction(error, String? message);

/// default error report callback function
SharkErrorFunction get onError => (err, message) {
      throw SharkError(message ?? err.toString());
    };

/// error report delegation, use this to report every exception
/// [report] method would transform error type to [SharkError]
///
/// sample:
/// try {
///   xxx
/// } catch (e) {
///   SharkReport.report(e, 'it's an error');
/// }
class SharkReport {
  static List<SharkErrorFunction> _errorReports = [onError];

  static throwSharkError({required String message}) {
    throw SharkError(message);
  }

  static addErrorReport(SharkErrorFunction errorFunction) {
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

void throwSharkError({required String message}) {
  SharkReport.throwSharkError(message: message);
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
