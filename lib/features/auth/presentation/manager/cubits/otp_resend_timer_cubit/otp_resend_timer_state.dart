import 'package:meta/meta.dart';

@immutable
abstract class OtpResendTimerState {}

class TimerInitial extends OtpResendTimerState {}

class TimerRunning extends OtpResendTimerState {
  final int timeLeft;
  TimerRunning(this.timeLeft);
}

class TimerFinished extends OtpResendTimerState {}
