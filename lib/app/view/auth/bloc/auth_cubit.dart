import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/view/auth/password_screen.dart';
import 'package:jetu.driver/app/widgets/app_toast.dart';
import 'package:jetu.driver/data/model/jetu_driver_model.dart';
import 'package:jetu.driver/data/model/jetu_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final GraphQLClient client;

  AuthCubit({
    required this.client,
  }) : super(AuthState.initial());

  late SharedPreferences _pref;

  void init() async {
    _pref = await SharedPreferences.getInstance();
    bool isLogged = _pref.getBool(AppSharedKeys.isLogged) ?? false;
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';

    //6ij4TNvmojRxK2gTDOCR7u50g793
    emit(state.copyWith(isLogged: isLogged, userId: userId));
    if (isLogged) {
      await checkStatus();
    }
  }

  Future<void> checkStatus() async {
    emit(state.copyWith(isLoading: true));
    final QueryOptions options = QueryOptions(
      document: gql(JetuAuthQuery.checkStatus()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "userId": state.userId,
      },
      parserFn: (json) =>
          JetuDriverModel.fromJson(json, name: "jetu_drivers_by_pk"),
    );

    QueryResult result = await client.query(options);
    JetuDriverModel check = result.parsedData as JetuDriverModel;

    emit(state.copyWith(status: check.status, isLoading: false));
  }

  Future<void> login({
    required BuildContext context,
    required String phone,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true));
    String phon = phone.replaceAll(RegExp(r"[^\w\s]+"), '');
    final QueryOptions options = QueryOptions(
      document: gql(JetuAuthQuery.isPasswordCorrect()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "phone": '+7$phon',
        "pass": password,
      },
      parserFn: (json) => JetuDriverList.fromUserJson(json),
    );

    QueryResult result = await client.query(options);
    JetuDriverList check = result.parsedData as JetuDriverList;
    emit(state.copyWith(isLoading: false));
    if (check.users.isEmpty) {
      AppToast.center('Пороль не верный!');
    }
    if (check.users.isNotEmpty) {
      _pref = await SharedPreferences.getInstance();
      _pref.setBool(AppSharedKeys.isLogged, true);
      _pref.setString(AppSharedKeys.userId, check.users.first.id ?? '');
      emit(state.copyWith(
        isLoading: false,
        isLogged: true,
        userId: check.users.first.id ?? '',
      ));
      Navigator.of(context).pop(true);
    }
  }

  void checkPhone({
    required BuildContext context,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));
    String phon = phone.replaceAll(RegExp(r"[^\w\s]+"), '');

    bool check = await isRegistered(phon);
    emit(state.copyWith(isLoading: false));

    if (check) {
      bool isSuccess = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .padding
                  .top,
            ),
            child: PasswordScreen(
              phone: phone,
            ),
          );
        },
      );
      emit(state.copyWith(
        isLoading: false,
        success: isSuccess,
        isLogged: isSuccess,
      ));
      if (isSuccess) {
        await checkStatus();
        AppNavigator.navigateToHome(context);
      }
    } else {
      AppNavigator.navigateToRegisterToWrite(
        context,
        title: 'Регистрация',
        desc: 'verificationId',
      );
    }
  }

  Future<bool> isRegistered(String phone) async {
    final QueryOptions options = QueryOptions(
      document: gql(JetuAuthQuery.isRegistered()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "phone": '+7$phone',
      },
      parserFn: (json) => JetuDriverList.fromUserJson(json),
    );

    QueryResult result = await client.query(options);
    JetuDriverList check = result.parsedData as JetuDriverList;
    if (check.users.isEmpty) {
      return false;
    }
    return true;
  }

  void logout(BuildContext context) async {
    _pref = await SharedPreferences.getInstance();
    _pref.setBool(AppSharedKeys.isLogged, false);
    _pref.setString(AppSharedKeys.userId, '');
    emit(state.copyWith(isLogged: false));
    AppNavigator.navigateToLogin(context);
  }
}
