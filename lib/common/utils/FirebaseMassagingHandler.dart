import 'dart:convert';
import 'package:ulearning/common/routes/names.dart';
import 'package:ulearning/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulearning/global.dart';

class FirebaseMassagingHandler {
  FirebaseMassagingHandler._();
  static AndroidNotificationChannel channel_call =
      const AndroidNotificationChannel(
    'com.dbestech.ulearning.call', // id
    'ulearning_call', // title
    importance: Importance.max,
    enableLights: true,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alert'),
  );
  static AndroidNotificationChannel channel_message =
      const AndroidNotificationChannel(
    'com.dbestech.ulearning.message', // id
    'ulearning_message', // title
    importance: Importance.defaultImportance,
    enableLights: true,
    playSound: true,
  );

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );


      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("FirebaseMessaging.onMessage.listen--->${message}");
        if (message != null) {
          _receiveNotification(message);
        }
      });
    } on Exception catch (e) {
      print("FirebaseMessaging.onMessage.listen--->${e}");
    }
  }

  static Future<void> _receiveNotification(RemoteMessage message) async {
    if (message.data != null && message.data["call_type"] != null) {
      //  ////1. voice 2. video 3. text, 4.cancel
      if (message.data["call_type"] == "voice") {
        var data = message.data;
        var to_token = data["token"];
        var to_name = data["name"];
        var to_avatar = data["avatar"];
        var doc_id = data["doc_id"] ?? "";
        if (to_token != null && to_name != null && to_avatar != null) {
          Global.TopSnakbarKey.currentState?.show(to_name, to_token, to_avatar,
              doc_id, "audience", "Voice call", AppRoutes.VoiceCall);
        }
      } else if (message.data["call_type"] == "video") {
        //  ////1. voice 2. video 3. text, 4.cancel
        var data = message.data;
        var to_token = data["token"];
        var to_name = data["name"];
        var to_avatar = data["avatar"];
        var doc_id = data["doc_id"] ?? "";
        if (to_token != null && to_name != null && to_avatar != null) {
          Global.TopSnakbarKey.currentState?.show(to_name, to_token, to_avatar,
              doc_id, "audience", "Video call", AppRoutes.VideoCall);
        }
      } else if (message.data["call_type"] == "cancel") {
        FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
        Global.TopSnakbarKey.currentState?.hide();
        var _prefs = await SharedPreferences.getInstance();
        await _prefs.setString("CallVocieOrVideo", "");
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("firebaseMessagingBackground--message-----${message}");
    if (message != null) {
      if (message.data != null && message.data["call_type"] != null) {
        if (message.data["call_type"] == "cancel") {
          FirebaseMassagingHandler.flutterLocalNotificationsPlugin.cancelAll();
          var _prefs = await SharedPreferences.getInstance();
          await _prefs.setString("CallVocieOrVideo", "");
        }
        if (message.data["call_type"] == "voice" ||
            message.data["call_type"] == "video") {
          var data = {
            "to_token": message.data["token"],
            "to_name": message.data["name"],
            "to_avatar": message.data["avatar"],
            "doc_id": message.data["doc_id"] ?? "",
            "call_type": message.data["call_type"],
            "expire_time": DateTime.now().toString(),
          };
          print("firebaseMessagingBackground-----${jsonEncode(data)}");
          var _prefs = await SharedPreferences.getInstance();
          await _prefs.setString("CallVocieOrVideo", jsonEncode(data));
        }
      }
    }
  }
}
