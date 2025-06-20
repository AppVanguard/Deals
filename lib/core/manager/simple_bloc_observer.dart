import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global observer that logs every Bloc event, transition, and error.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('[${bloc.runtimeType}] Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('[${bloc.runtimeType}] $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('[${bloc.runtimeType}] Error: $error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
