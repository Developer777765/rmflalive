import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';

enum Options { sync, download, logout }

final HomePageDropDownProvider =
    StateNotifierProvider<HomePageDropdowNotifier, int?>((ref) {
  return HomePageDropdowNotifier();
});

Future<void> _showLogoutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const SingleChildScrollView(
          child: Text(
            'Do you want to logout ?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              GoRouter.of(context).pushReplacementNamed(Routes.loginScreen);
            },
          ),
        ],
      );
    },
  );
}

class HomePageDropdowNotifier extends StateNotifier<int?> {
  HomePageDropdowNotifier() : super(0);

  void changeValue(int value, BuildContext context) {
    state = value;
    if (state == Options.sync.index) {
      debugPrint("sync selected$state");
    } else if (state == Options.download.index) {
      debugPrint(" Download selected$state");
    } else if (state == Options.logout.index) {
      _showLogoutDialog(context);
      debugPrint(" logout selected$state");
    }
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
