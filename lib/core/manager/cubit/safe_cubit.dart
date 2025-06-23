import 'package:flutter_bloc/flutter_bloc.dart';

/// A cubit that guards against emitting states after it has been closed.
abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(State initialState) : super(initialState);

  @override
  void emit(State state) {
    if (!isClosed) {
      super.emit(state);
    }
  }
}
