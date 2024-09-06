import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/main.dart';

final autoLogoutProvider =
    StateNotifierProvider<AutoLogoutNotifier, int>((ref) {
  return AutoLogoutNotifier();
});

class AutoLogoutNotifier extends StateNotifier<int> {
  AutoLogoutNotifier() : super(0);

  Timer? _timer;
  AlertDialog? _dialog;

  void start() {
    _timer = Timer.periodic(const Duration(minutes: 12), (timer) {
      state++;
      debugPrint("Logout State : $state");
      if (state == 2) {
        if (_dialog != null) {
          Navigator.of(navigatorKey.currentState!.context).pop();
          _dialog = null;
        }

        _dialog = AlertDialog(
          title: const Text('Alert Message'),
          content: const Text('Your session has expired'),
          actions: [
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Ok"),
            )
          ],
        );

        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (context) {
            return WillPopScope(onWillPop: () async => false, child: _dialog!);
          },
        );
        timer.cancel();
        state = 0;
      }
    });
  }

  void reset() {
    _timer!.cancel();
    state = 0;
    start();
  }
}

Widget generalsession({required WidgetRef ref, required Widget child}) {
  return Listener(
    child: child,
    onPointerDown: (_) {
      debugPrint("onTapDown is work");
      ref.watch(autoLogoutProvider.notifier).reset();
    },
    onPointerMove: (_) {
      debugPrint("onTapDown is work");
      ref.read(autoLogoutProvider.notifier).reset();
    },
    onPointerUp: (_) {
      debugPrint("onTapDown is work");
      ref.watch(autoLogoutProvider.notifier).reset();
    },
    onPointerSignal: (_) {
      debugPrint("onTapDown is work");
      ref.watch(autoLogoutProvider.notifier).reset();
    },
  );
}
