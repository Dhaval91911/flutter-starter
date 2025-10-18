import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpTimerState {
  final int secondsRemaining;
  final bool canResend;
  const OtpTimerState({this.secondsRemaining = 120, this.canResend = false});
}

class OtpTimerNotifier extends StateNotifier<OtpTimerState> {
  final Ref ref;
  Timer? _timer;

  OtpTimerNotifier(this.ref) : super(const OtpTimerState());

  void start() {
    if (_timer?.isActive == true) return; // prevent resetting if already running
    _timer?.cancel();
    state = const OtpTimerState(secondsRemaining: 120, canResend: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsRemaining <= 1) {
        t.cancel();
        state = const OtpTimerState(secondsRemaining: 0, canResend: true);
      } else {
        state = OtpTimerState(secondsRemaining: state.secondsRemaining - 1, canResend: false);
      }
    });
  }

  void restart() {
    _timer?.cancel();
    state = const OtpTimerState(secondsRemaining: 120, canResend: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsRemaining <= 1) {
        t.cancel();
        state = const OtpTimerState(secondsRemaining: 0, canResend: true);
      } else {
        state = OtpTimerState(secondsRemaining: state.secondsRemaining - 1, canResend: false);
      }
    });
  }

  void reset() {
    _timer?.cancel();
    state = const OtpTimerState(secondsRemaining: 120, canResend: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final otpTimerProvider = StateNotifierProvider.autoDispose<OtpTimerNotifier, OtpTimerState>((ref) {
  final notifier = OtpTimerNotifier(ref);
  ref.onDispose(() => notifier.dispose());
  return notifier;
});
