abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  Failure? get failure => isFailure ? (this as Failure<T>).failure : null;
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success: $data';
}

class Failure<T> extends Result<T> {
  @override
  final Failure failure;
  const Failure(this.failure);

  @override
  String toString() => 'Failure: $failure';
}
