import 'dart:async';

extension StreamExtensions<T> on Stream<T> {
  Future<T> firstNextElementWith(bool Function(T) toTest) {
    Completer<T> completer = Completer<T>();
    late StreamSubscription<T> streamSubscription;

    streamSubscription = listen((element) {
      if (toTest(element)) {
        completer.complete(element);
        streamSubscription.cancel();
      }
    });

    return completer.future;
  }
}
