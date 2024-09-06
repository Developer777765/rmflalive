import 'dart:async';
import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menthee_flutter_project/data/datasource/loacal_database/shared_pref.dart';
import '/core/assets_manager.dart';
import '/core/router.dart';
import '../../provider/network_listener_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

final androidUniqueIdProvider = StateProvider<String>((ref) {
  return "";
});

final brNameProvider = StateProvider<String>((ref) {
  return "";
});

Future<String> getAndroidId() async {
  String androidId =
      await const MethodChannel('android.provider.Settings.Secure')
          .invokeMethod('getString', 'android_id');
  debugPrint("get android :");
  debugPrint(androidId);
  return androidId;
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? timer;
  AndroidId _androidIdPlugin = const AndroidId();

  void _startdelay() {
    timer = Timer(const Duration(seconds: 2), () {
      _goNext();
    });
  }

  void getUniqueId() async {
    var branchName = await Helper.getbranchName();
    debugPrint("branchname : $branchName");
    ref
        .read(brNameProvider.notifier)
        .update((state) => state = branchName ?? "");
    final String? androidId = await _androidIdPlugin.getId();
    ref
        .read(androidUniqueIdProvider.notifier)
        .update((state) => androidId!); //"14c83af3f7373f9b"
    debugPrint("device ID =  ${ref.read(androidUniqueIdProvider)}");
  }

  _goNext() {
    context.go(Routes.loginScreen);
  }

  @override
  void initState() {
    getUniqueId();
    super.initState();
    ref.read(connectivityStatusProviders);
    _startdelay();
    getDeviceInfo();
  }

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

// Android
  late AndroidDeviceInfo info;
  Future<void> getDeviceInfo() async {
    info = await deviceInfo.androidInfo;

    debugPrint("manufacturer : ${info.manufacturer}");
    debugPrint(info.hardware);
    debugPrint(info.product);
    debugPrint(info.model);
    ref.read(deviceModelProvider.notifier).state = false;
    // if (info.model == "M2-Pro") {
    // } else {
    //   ref.read(deviceModelProvider.notifier).state = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7)
            ])),
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    ImageAssets.repcoLogo,
                    scale: 1.4,
                  ),
                )
              ],
            )),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7)
          ])),
          height: size.width * 0.15,
          width: size.width,
          child: Center(
            child: Text(
              'Powered by Menthee Technologies',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ));
  }
}

final deviceModelProvider = StateProvider<bool>((ref) {
  return false;
});


// https://uxcam.com/blog/mobile-app-best-practices/

 