import 'package:flutter_bloc/flutter_bloc.dart';

mixin CubitPreventsEmitOnClosed<T> on Cubit<T> {
  @override
  void emit(T state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
