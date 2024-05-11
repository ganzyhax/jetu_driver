import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jetu.driver/app/app.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/services/firebase_notification.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() async {
  AndroidYandexMap.useAndroidViewSurface = false;

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await initHiveForFlutter();
  FirebaseNotificationsManager.initialize();
  final client = await GraphQlService.init();
  await setGraphClient(client.value);
  await Geolocator.requestPermission();
  SharedPreferences _pref = await SharedPreferences.getInstance();
  AndroidYandexMap.useAndroidViewSurface = false;
  runApp(
    JetuDriver(
      client: client,
      isLogged: _pref.getBool(AppSharedKeys.isLogged) ?? false,
    ),
  );
}
