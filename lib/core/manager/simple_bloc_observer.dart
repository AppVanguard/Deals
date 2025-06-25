import 'package:deals/core/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global observer that logs every Bloc event, transition, and error.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    appLog('[${bloc.runtimeType}] Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    appLog('[${bloc.runtimeType}] $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    appLog('[${bloc.runtimeType}] Error: $error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
