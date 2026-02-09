sealed class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.value);
  T value;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.error);
  String error;
}
