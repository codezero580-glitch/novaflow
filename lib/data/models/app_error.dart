class AppError {
  final String message;
  final String source;
  final dynamic raw;

  AppError({
    required this.message,
    required this.source,
    this.raw,
  });
}