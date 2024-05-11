import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:jetu.driver/app/app_router/app_router.gr.dart';
import 'package:jetu.driver/app/const/app_shared_keys.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/services/jetu_drivers/grapql_mutation.dart';
import 'package:jetu.driver/app/view/balance/bloc/transaction_cubit.dart';
import 'package:jetu.driver/gateway/graphql_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase/supabase.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentWeb extends StatefulWidget {
  PaymentWeb(
      {Key? key,
      required this.addBalance,
      required this.untilBalance,
      required this.driverId})
      : super(key: key);
  String addBalance;
  String untilBalance;
  String driverId;
  @override
  _PaymentWebState createState() => _PaymentWebState();
}

class _PaymentWebState extends State<PaymentWeb> {
  late WebViewController controller;
  Map<String, dynamic>? paymentIntentData;

  bool isLoad = false;
  Future<void> addAmount(String amount) async {
    try {
      // final queryParameters = {
      //   "driver_id": widget.userId,
      //   "amount": amount,
      // };

      // var url = Uri.https(
      //   'jetu-backend.vercel.app',
      //   'api/v1/add_balance',
      //   queryParameters,
      // );

      // final res = await http.get(url);
      double untilBalance = double.parse(widget.untilBalance);
      double addBalance = double.parse(widget.addBalance);
      double updateBalance = untilBalance + addBalance;
      SharedPreferences _pref = await SharedPreferences.getInstance();
      String driverId = _pref.getString(AppSharedKeys.userId) ?? '';
      print('Trying to add ' + updateBalance.toString());
      final client = await GraphQlService.init();

      final MutationOptions options = MutationOptions(
        document: gql(JetuDriverMutation.addDriverBalance()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {"driverId": driverId, "amount": updateBalance},
      );

      final data = await client.value.mutate(options);
      /////////
      final MutationOptions options2 = MutationOptions(
        document: gql(JetuDriverMutation.createTransaction()),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          "object": {
            "driver_id": driverId,
            "amount": addBalance,
            "type": 'Пополнение'
          }
        },
      );

      final res = await client.value.mutate(options2);
      print(res);
    } catch (r) {
      print(r);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoad == false)
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Баланс',
                style: TextStyle(color: Colors.black),
              ),
              leading: BackButton(
                color: Colors.black,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              debuggingEnabled: true,
              javascriptChannels: <JavascriptChannel>{
                JavascriptChannel(
                  name: 'flutter',
                  onMessageReceived: (JavascriptMessage message) async {
                    if (message.message == 'Success') {
                      await addAmount(widget.addBalance);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      context.router.push(
                        BalanceScreen(
                          userId: widget.driverId,
                          showBackButton: true,
                        ),
                      );
                    } else if (message.message == 'Fail') {
                      print(message.message);
                    }
                  },
                ),
              },
              initialUrl: 'https://cloudpayment-web.vercel.app/?amount=' +
                  widget.addBalance,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onPageStarted: (url) async {},
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            )));
  }
}
