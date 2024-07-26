import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning/common/routes/routes.dart';
import 'package:ulearning/common/style/theme.dart';
import 'package:ulearning/common/utils/FirebaseMassagingHandler.dart';
import 'package:ulearning/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Global.init();
  runApp(MyApp());
  firebaseInit().whenComplete(() {
    FirebaseMassagingHandler.config();
  });
}
Future firebaseInit() async {
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMassagingHandler.firebaseMessagingBackground,
  );
  if (Platform.isAndroid) {
    FirebaseMassagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMassagingHandler.channel_call);
    FirebaseMassagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMassagingHandler.channel_message);
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: ScreenUtilInit(
            designSize: Size(375, 812),
            builder: (context, child) => MaterialApp(
              title: 'ulearning',
              theme: AppTheme.light,
              navigatorKey: Global.navigatorKey,
              scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
              builder: Global.MaterialAppBuilder(),
              debugShowCheckedModeBanner: false,
              navigatorObservers: [AppPages.observer],
              initialRoute: AppRoutes.INITIAL,
              onGenerateRoute: AppPages.GenerateRouteSettings,
            ))
    );
  }
}

