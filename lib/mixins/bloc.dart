import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocPreventsEmitOrAddOnClosed<Event, State> on Bloc<Event, State> {
  @override
  void emit(State state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member
      super.emit(state);
    }
  }

  @override
  void add(Event event) {
    if (!isClosed) {
      super.add(event);
    }
  }
}
