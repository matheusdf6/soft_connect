class SoftConnectException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  SoftConnectException({
    this.message = 'An error with Soft Connect occurred',
    this.stackTrace,
  });

  @override
  String toString() => message;
}
