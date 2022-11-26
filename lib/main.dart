import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/app.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/view/auth/login_screen.dart';
import 'package:jetu.driver/app/view/home/home_screen.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru');
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  await initHiveForFlutter();
  final client = await GraphQlService.init();

  await setGraphClient(client.value);
  await Geolocator.requestPermission();
  SharedPreferences _pref = await SharedPreferences.getInstance();

  runApp(
    JetuDriver(
      client: client,
      child: getScreen(
        isLogged: _pref.getBool(AppSharedKeys.isLogged) ?? false,
      ),
    ),
  );
}

Widget getScreen({required bool isLogged}) {
  if (isLogged) {
    return HomeScreen();
  }
  return LoginScreen();
}
