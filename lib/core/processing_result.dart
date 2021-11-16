enum ProcessingState { unknown, success, transientError, blockingError }

class BaseProcessingResult<T> {
  final ProcessingState state;
  final T? result;
  final String error;

  BaseProcessingResult({required this.state, required this.result, this.error = ""});

  factory BaseProcessingResult.ok(dynamic result) =>
      BaseProcessingResult<T>(state: ProcessingState.success, result: result, error: "");

  factory BaseProcessingResult.blockingError(String error) =>
      BaseProcessingResult<T>(state: ProcessingState.blockingError, result: null, error: error);

  factory BaseProcessingResult.transientError(String error) =>
      BaseProcessingResult<T>(state: ProcessingState.transientError, result: null, error: error);

  factory BaseProcessingResult.unknownError(String error) =>
      BaseProcessingResult<T>(state: ProcessingState.unknown, result: null, error: error);

  bool isSuccess() => state == ProcessingState.success;
  bool isFailed() => state != ProcessingState.success;
}
