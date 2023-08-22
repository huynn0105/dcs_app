abstract class DataState<T> {
  final T? data;
  final String? errorMessage;

  const DataState({
    this.data,
    this.errorMessage,
  });
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed({String? errorMessage}) : super(errorMessage: errorMessage);
}

class DataNotSet<T> extends DataState<T> {
  const DataNotSet();
}
