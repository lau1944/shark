class Result {
  Result._();

  factory Result.success({required data}) => Success(data: data);

  factory Result.error({exception, String? message}) =>
      Error(exception: exception, message: message);
}

class Success extends Result {
  final data;

  Success({required this.data}) : super._();
}

class Error extends Result {
  final exception;
  final String? message;

  Error({this.exception, this.message}) : super._();
}
