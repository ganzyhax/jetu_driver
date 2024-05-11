import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotificationsManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
              onDidReceiveLocalNotification: onDidReceiveLocalNotification,
            ),
            android: AndroidInitializationSettings('@mipmap/launcher_icon'));
    _notificationsPlugin.initialize(initializationSettings);
    requestPermission();
    setupFirebaseMessagingListeners();
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    String? userToken = await FirebaseMessaging.instance.getToken();

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserToken()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": userToken.toString()},
    );
    final client = await GraphQlService.init();
    await client.value.mutate(options);
  }

  static void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    showNotification(
      title: title.toString(),
      body: body.toString(),
    );
  }

  static void setupFirebaseMessagingListeners() {
    FirebaseMessaging.instance.subscribeToTopic('all');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Here, navigate to specific screen based on message
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification != null) {
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    }
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'jetu_driver',
      'jetu_driver_channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(id, title, body, platformChannelSpecifics,
        payload: payload);
  }
}
