import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/app_navigator.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_auth/grapql_query.dart';
import 'package:jetu.driver/app/services/jetu_auth/jetu_auth.dart';
import 'package:jetu.driver/app/view/auth/verify_screen.dart';
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

    emit(state.copyWith(isLogged: isLogged, userId: userId));
    if (isLogged) {
      await checkStatus();
    }
  }

  Future<void> checkStatus() async {
    print('checkStatus');
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

  void login({
    required BuildContext context,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));
    String phon = phone.replaceAll(RegExp(r"[^\w\s]+"), '');

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.setSettings(appVerificationDisabledForTesting: false);
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+7$phon',
      verificationCompleted: (credential) {},
      verificationFailed: (FirebaseAuthException e) async {
        print(e);
        AppToast.center('Ошибка: Попробуйте еще раз!');
        emit(state.copyWith(isLoading: false));
      },
      codeSent: (verificationId, resendToken) async {
        emit(state.copyWith(isLoading: false));
        bool isSuccess = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .padding
                    .top,
              ),
              child: VerifyScreen(
                phone: phone,
                verificationId: verificationId,
              ),
            );
          },
        );
        emit(state.copyWith(
          isLoading: false,
          success: isSuccess,
        ));
        if (isSuccess) {
          await checkStatus();
          AppNavigator.navigateToHome(context);
        }
        ;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  void verify({
    required BuildContext context,
    required String verificationId,
    required String code,
    required String phone,
  }) async {
    emit(state.copyWith(isLoading: true));
    _pref = await SharedPreferences.getInstance();
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );
    final UserCredential cr =
        await FirebaseAuth.instance.signInWithCredential(credential);
    String userId = cr.user?.uid ?? '';
    String pho = '+7${phone.replaceAll(RegExp(r"[^\w\s]+"), '')}';

    if (!await isRegistered(pho)) {
      AppNavigator.navigateToRegister(context, userId: userId, phone: pho);
      emit(state.copyWith(isLoading: false));
    } else {
      _pref.setBool(AppSharedKeys.isLogged, true);
      _pref.setString(AppSharedKeys.userId, userId);
      emit(state.copyWith(
        isLoading: false,
        isLogged: true,
        userId: userId,
      ));
      await checkStatus();
      Navigator.of(context).pop(true);
    }
  }

  Future<bool> isRegistered(String phone) async {
    final QueryOptions options = QueryOptions(
      document: gql(JetuAuthQuery.isRegistered()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "phone": phone,
      },
      parserFn: (json) => JetuDriverList.fromUserJson(json),
    );

    QueryResult result = await client.query(options);
    print('${result.data},: ${result.exception}');
    JetuDriverList check = result.parsedData as JetuDriverList;
    if (check.users.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> updateUserData(
    BuildContext context, {
    required String userId,
    required String name,
    required String surname,
    required String phone,
    required String carModel,
    required String carColor,
    required String carNumber,
  }) async {
    emit(state.copyWith(isLoading: true, success: false));
    final MutationOptions options = MutationOptions(
      document: gql(JetuAuthMutation.insertDriverDate()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        "object": {
          "id": userId,
          "name": name.isNotEmpty ? name : null,
          "surname": surname.isNotEmpty ? surname : null,
          "phone": phone.isNotEmpty ? phone : null,
          "car_model": carModel.isNotEmpty ? carModel : null,
          "car_color": carColor.isNotEmpty ? carColor : null,
          "car_number": carNumber.isNotEmpty ? carNumber : null,
        }
      },
      parserFn: (json) => JetuUserModel.fromJson(json),
    );

    await client.mutate(options);
    emit(state.copyWith(isLoading: false));
    await checkStatus();
    AppNavigator.navigateToHome(context);
  }

  void logout(BuildContext context) async {
    _pref = await SharedPreferences.getInstance();
    _pref.setBool(AppSharedKeys.isLogged, false);
    _pref.setString(AppSharedKeys.userId, '');
    emit(state.copyWith(isLogged: false));
    AppNavigator.navigateToLogin(context);
  }
}
