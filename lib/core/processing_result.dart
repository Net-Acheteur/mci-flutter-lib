enum ProcessingState { unknown, success, transientError, blockingError }

class ProcessingResult<T> {
  final ProcessingState state;
  final T? result;
  final String error;

  ProcessingResult({required this.state, required this.result, this.error = ""});

  factory ProcessingResult.ok(dynamic result) =>
      ProcessingResult<T>(state: ProcessingState.success, result: result, error: "");

  factory ProcessingResult.blockingError(String error) =>
      ProcessingResult<T>(state: ProcessingState.blockingError, result: null, error: error);

  factory ProcessingResult.transientError(String error) =>
      ProcessingResult<T>(state: ProcessingState.transientError, result: null, error: error);

  factory ProcessingResult.unknownError(String error) =>
      ProcessingResult<T>(state: ProcessingState.unknown, result: null, error: error);

  bool isSuccess() => state == ProcessingState.success;
  bool isFailed() => state != ProcessingState.success;
}
