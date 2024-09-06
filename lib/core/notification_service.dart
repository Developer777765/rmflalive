import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final uniqueIdNotificationProvider = StateProvider<int>((ref) {
  return 0;
});

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('repco_1');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse:
      //     (NotificationResponse notificationResponse) {
      //   onDidReceiveBgRes(notificationResponse).name;
      //   onSelectNotification(notificationResponse.payload);
      // }(NotificationResponse(
      //         notificationResponseType:
      //             NotificationResponseType.selectedNotificationAction)),
      // onDidReceiveNotificationResponse: onDidReceiveNotificationRes
    );
  }

  // @pragma('vm:entry-point')
  // NotificationResponseType onDidReceiveBgRes(
  //         NotificationResponse notificationResponse) =>
  //     notificationResponse.notificationResponseType;

  // @pragma('vm:entry-point')
  // void onDidReceiveNotificationRes(
  //         NotificationResponse notificationResponse) async =>
  //     onSelectNotification(notificationResponse.payload);

  // Future<void> onSelectNotification(String? payload) async {
  //   final result = await Permission.storage.request();
  //   if (result == PermissionStatus.granted) {
  //     // final directory = await pickDirectory();
  //     // if (directory != null) {
  //     //   print("notification");
  //     //   await SystemChannels.platform.invokeMethod<void>(
  //     //     'OpenFilePicker',
  //     //     <String, dynamic>{
  //     //       'type': 'DOWNLOADS',
  //     //       'path': directory.path,
  //     //     },
  //     //   );
  //     // }
  //   }
  // }

  // Future<Directory?> pickDirectory() async {
  //   try {
  //     final directory = await FilePicker.platform.getDirectoryPath();
  //     if (directory != null) {
  //       return Directory(directory);
  //     }
  //   } on PlatformException catch (e) {
  //     print("Unsupported operation" + e.toString());
  //   }
  //   return null;
  // }

  // void notificationTapBackground(NotificationResponse notificationResponse) {
  //   notificationResponse.notificationResponseType.name;

  //   // handle action
  // }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        color: Colors.lightGreen,
        ticker: 'ticker',
        playSound: true,
        enableLights: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(''),
        icon: 'repco_1',
        //  smallIcon: 'repco_1'
      ),
    );
  }

  // Future<void> onNotificationPressed(String? payload) async {
  //   await onSelectNotification(payload);
  // }

  Future showDownloadedNotification(
      int id, String path, String title, String body) async {
    return await notificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
    );
  }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payLoad}) async {
  //   return notificationsPlugin.show(
  //       id, title, body, await notificationDetails());
  // }
}

// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('repco_1');

//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse:
//             (NotificationResponse notificationResponse) {
//           onDidReceiveBgRes(notificationResponse).name;
//           onSelectNotification(notificationResponse.payload);
//         }(NotificationResponse(
//                 notificationResponseType:
//                     NotificationResponseType.selectedNotificationAction)),
//         onDidReceiveNotificationResponse: onDidReceiveNotificationRes);
//   }

//   @pragma('vm:entry-point')
//   NotificationResponseType onDidReceiveBgRes(
//           NotificationResponse notificationResponse) =>
//       notificationResponse.notificationResponseType;

//   @pragma('vm:entry-point')
//   void onDidReceiveNotificationRes(
//           NotificationResponse notificationResponse) async =>
//       onSelectNotification(notificationResponse.payload);

//   Future<void> onSelectNotification(String? payload) async {
//     final result = await Permission.storage.request();
//     if (result == PermissionStatus.granted) {
//       final directory = await pickDirectory();
//       if (directory != null) {
//         await SystemChannels.platform.invokeMethod<void>(
//           'OpenFilePicker',
//           <String, dynamic>{
//             'type': 'DOWNLOADS',
//             'path': directory.path,
//           },
//         );
//       }
//     }
//   }

//   Future<Directory?> pickDirectory() async {
//     try {
//       final directory = await FilePicker.platform.getDirectoryPath();
//       if (directory != null) {
//         return Directory(directory);
//       }
//     } on PlatformException catch (e) {
//       print("Unsupported operation" + e.toString());
//     }
//     return null;
//   }

//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     notificationResponse.notificationResponseType.name;

//     // handle action
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your_channel_id',
//         'your_channel_name',
//         channelDescription: 'your_channel_description',
//         importance: Importance.max,
//         priority: Priority.high,
//         color: Colors.lightGreen,
//         ticker: 'ticker',
//         playSound: true,
//         enableLights: true,
//         enableVibration: true,
//         styleInformation: BigTextStyleInformation(''),
//         icon: 'repco_1',
//         //  smallIcon: 'repco_1'
//       ),
//     );
//   }

//   Future<void> onNotificationPressed(String? payload) async {
//     await onSelectNotification(payload);
//   }

//   Future showDownloadedNotification(
//       int id, String path, String title, String body) async {
//     return await notificationsPlugin
//         .show(id, title, body, await notificationDetails(), payload: path);
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }
// }


// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('repco_1');

//     var initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveBackgroundNotificationResponse:
//             (NotificationResponse notificationResponse) {
//           onDidReceiveBgRes(notificationResponse).name;
//           SystemChannels.platform.invokeMethod<void>(
//             'OpenFilePicker',
//             <String, dynamic>{
//               'type': 'DOWNLOADS',
//               'path': "/storage/emulated/0/Download",
//             },
//           );
//         }(NotificationResponse(
//                 notificationResponseType:
//                     NotificationResponseType.selectedNotificationAction)),
//         onDidReceiveNotificationResponse: onDidReceiveNotificationRes);
//   }

//   @pragma('vm:entry-point')
//   NotificationResponseType onDidReceiveBgRes(
//           NotificationResponse notificationResponse) =>
//       notificationResponse.notificationResponseType;

//   @pragma('vm:entry-point')
//   void onDidReceiveNotificationRes(
//           NotificationResponse notificationResponse) async =>
//       await SystemChannels.platform.invokeMethod<void>(
//         'OpenFilePicker',
//         <String, dynamic>{
//           'type': 'DOWNLOADS',
//           'path': "/storage/emulated/0/Download",
//         },
//       );

//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     notificationResponse.notificationResponseType.name;

//     // handle action
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your_channel_id',
//         'your_channel_name',
//         channelDescription: 'your_channel_description',
//         importance: Importance.max,
//         priority: Priority.high,
//         color: Colors.lightGreen,
//         ticker: 'ticker',
//         playSound: true,
//         enableLights: true,
//         enableVibration: true,
//         styleInformation: BigTextStyleInformation(''),
//         icon: 'repco_1',
//         //  smallIcon: 'repco_1'
//       ),
//     );
//   }

//   Future<void> onSelectNotification(String? payload) async {
//     await SystemChannels.platform.invokeMethod<void>(
//       'OpenFilePicker',
//       <String, dynamic>{
//         'type': 'DOWNLOADS',
//         'path': payload,
//       },
//     );
//   }

//   Future showDownloadedNotification(
//       int id, String path, String title, String body) async {
//     return await notificationsPlugin
//         .show(id, title, body, await notificationDetails(), payload: path);
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }

//   Future<void> onNotificationPressed(String? payload) async {
//     await SystemChannels.platform.invokeMethod<void>(
//       'OpenFilePicker',
//       <String, dynamic>{
//         'type': 'DOWNLOADS',
//       },
//     );
//   }
// }


// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('repco_1');

//     var initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});

//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'your_channel_id',
//         'your_channel_name',
//         channelDescription: 'your_channel_description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//         playSound: true,
//         enableLights: true,
//         enableVibration: true,
//         styleInformation: BigTextStyleInformation(''),
//       ),
//     );
//   }

//   Future<void> onSelectNotification(String? payload) async {
//     await SystemChannels.platform.invokeMethod<void>(
//       'OpenFilePicker',
//       <String, dynamic>{
//         'type': 'DOWNLOADS',
//         'path': payload,
//       },
//     );
//   }

//   Future showDownloadedNotification(String path) async {
//     return await notificationsPlugin.show(0, 'Downloaded File',
//         'Click here to open Downloads folder', await notificationDetails(),
//         payload: '/storage/emulated/0/Download');
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }

//   Future<void> onNotificationPressed(String? payload) async {
//     await SystemChannels.platform.invokeMethod<void>(
//       'OpenFilePicker',
//       <String, dynamic>{
//         'type': 'DOWNLOADS',
//       },
//     );
//   }
// }
