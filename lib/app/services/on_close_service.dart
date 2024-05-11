import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _handleAppPaused();
    }
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
    if (state == AppLifecycleState.detached) {
      _handleAppClosed();
    }
  }

  Future<void> _handleAppPaused() async {
    print('PAUSED');
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserIsBackground()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": true},
    );
    final client = await GraphQlService.init();
    var data = await client.value.mutate(options);
    print(data);
  }

  Future<void> _handleAppResumed() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';
    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserIsBackground()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": false},
    );
    final client = await GraphQlService.init();
    await client.value.mutate(options);
  }

  Future<void> _handleAppClosed() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString(AppSharedKeys.userId) ?? '';

    final client = await GraphQlService.init();

    final MutationOptions options = MutationOptions(
      document: gql(JetuDriverMutation.updateUserFreeStatus()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": false},
    );

    await client.value.mutate(options);

    final MutationOptions options2 = MutationOptions(
      document: gql(JetuDriverMutation.updateUserIsBackground()),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {"userId": userId, "value": false},
    );
    await client.value.mutate(options2);
    log('must update isfree and backftournd');
  }
}
