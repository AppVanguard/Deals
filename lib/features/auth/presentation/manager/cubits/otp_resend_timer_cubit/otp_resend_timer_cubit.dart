import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_resend_timer_state.dart';

class OtpResendTimerCubit extends Cubit<OtpResendTimerState> {
  Timer? _timer;
  int _timeLeft = 60;

  OtpResendTimerCubit() : super(TimerInitial());

  /// Starts the 60-second countdown.
  void startTimer() {
    _timer?.cancel();
    _timeLeft = 60;
    emit(TimerRunning(_timeLeft));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeLeft--;
      if (_timeLeft <= 0) {
        timer.cancel();
        emit(TimerFinished());
      } else {
        emit(TimerRunning(_timeLeft));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
