class Result<T> {
  final T? data;
  final String message;
  final bool isSuccess;

  Result({
    this.data,
    required this.message,
    required this.isSuccess,
  });

  factory Result.success (T data, {String message = "Successful"}) {
    return Result (
      data: data,
      message: message,
      isSuccess: true,
    );
  }

  factory Result.failure(String message) {
    return Result (
      message: message,
      isSuccess: false,
    );
  }
}