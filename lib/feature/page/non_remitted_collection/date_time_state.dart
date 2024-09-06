import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentDateTimeProvider =
    StateNotifierProvider<CurrentDateTime, DateTime>((ref) {
  return CurrentDateTime();
});

class CurrentDateTime extends StateNotifier<DateTime> {
  CurrentDateTime() : super(DateTime.now()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = DateTime.now();
    });
  }

  late final Timer _timer;
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}