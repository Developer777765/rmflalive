import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/core/router.dart';

import 'app_theme.dart';

// ignore: must_be_immutable

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     return MaterialApp.router(
//       routerConfig: goRouter,
//       theme: AppTheme.lightTheme(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Register the observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Unregister the observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
        // systemNavigationBarColor: Theme.of(context).colorScheme.primary),
        ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter, // Use routerDelegate instead of routerConfig
      theme: AppTheme.lightTheme(),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {

  //   }
  // }
}
