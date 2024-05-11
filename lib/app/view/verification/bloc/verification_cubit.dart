import 'dart:io';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:nhost_flutter_auth/nhost_flutter_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../const/app_shared_keys.dart';

part 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final GraphQLClient client;

  VerificationCubit({
    required this.client,
  }) : super(VerificationState.initial());

  void setPhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  void setUserInfo(Map<String, dynamic> userInfo) {
    emit(state.copyWith(userInfo: userInfo));
  }

  void setImage1(File? image) {
    emit(state.copyWith(image1: image));
  }

  void setImage2(File? image) {
    emit(state.copyWith(image2: image));
  }

  void setImage3(File? image) {
    emit(state.copyWith(image3: image));
  }

  Future<bool> sendData() async {
    try {
      emit(state.copyWith(isLoading: true));
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String pass = _pref.getString(AppSharedKeys.password) ?? '';

      String driverId = getUniqueValue();
      await uploadImage(state.image1!, driverId: driverId);
      await uploadImage(state.image2!, driverId: driverId);
      await uploadImage(state.image3!, driverId: driverId);

      emit(state.copyWith(isLoading: false));

      String phone = state.phone;
      String name = state.userInfo["name"];
      String surname = state.userInfo["surname"];
      String carModel = state.userInfo["car_model"];
      String carColor = state.userInfo["car_color"];
      String carNumber = state.userInfo["car_number"];

      final MutationOptions options = MutationOptions(
        document: gql(JetuDriverMutation.insertDriverDate()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "object": {
            "id": driverId,
            "name": name.isNotEmpty ? name : null,
            "surname": surname.isNotEmpty ? surname : null,
            "phone": phone.isNotEmpty
                ? '+7${phone.replaceAll(RegExp(r"[^\w\s]+"), '')}'
                : null,
            "password": pass,
            "car_model": carModel.isNotEmpty ? carModel : null,
            "car_color": carColor.isNotEmpty ? carColor : null,
            "car_number": carNumber.isNotEmpty ? carNumber : null,
            "is_verified": false,
          }
        },
      );

      final res = await client.mutate(options);

      await _pref.setBool(AppSharedKeys.isLogged, true);
      await _pref.setString(AppSharedKeys.userId, driverId ?? '');
      emit(state.copyWith(
        isLoading: false,
        success: true,
      ));
      return true;
    } catch (err) {
      emit(state.copyWith(isLoading: false, error: 'Ошибка при отправке'));
      return false;
    }
  }

  Future<void> uploadImage(File file, {String driverId = ''}) async {
    try {
      final auth = NhostAuthClient(
        url: "https://elmrnhqzybgkyhthobqy.auth.eu-central-1.nhost.run/v1",
      );

      final storage = NhostStorageClient(
        url: 'https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1',
        session: auth.userSession,
      );
      final res = await auth.signInEmailPassword(
        email: 'user-1@nhost.io',
        password: 'password-1',
      );

      final imageResponse = await storage.uploadBytes(
        fileName: '${Platform.operatingSystem}_${getUniqueValue()}',
        fileContents: await file.readAsBytes(),
        mimeType: 'image/jpeg',
        bucketId: 'driver_documents',
      );

      String imageLink =
          "https://elmrnhqzybgkyhthobqy.storage.eu-central-1.nhost.run/v1/files/${imageResponse.id}";

      final MutationOptions options = MutationOptions(
        document: gql(JetuDriverMutation.insertDriverDocImages()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "object": {
            "driver_id": driverId,
            "url": imageLink,
            "resource_id": imageResponse.id
          }
        },
      );

      final ress = await client.mutate(options);
      print("uploadPhone: ${ress.exception}");
    } catch (err) {
      print('image err: $err');
    }
  }

  static String getUniqueValue() {
    var uuid = const Uuid();
    return uuid.v1();
  }
}
