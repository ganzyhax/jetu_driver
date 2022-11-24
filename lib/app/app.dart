import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jetu.driver/app/view/auth/bloc/auth_cubit.dart';
import 'package:jetu.driver/app/view/home/bloc/current_location_cubit.dart';
import 'package:jetu.driver/app/view/home/bloc/home_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:jetu.driver/app/widgets/app_loader.dart';
import 'package:loader_overlay/loader_overlay.dart';

class JetuDriver extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;
  final Widget child;

  const JetuDriver({
    Key? key,
    required this.client,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(client: client.value)..init(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => HomeCubit(client: client.value)
                ..init()
                ..updateLocation(),
            ),
            BlocProvider(
              create: (context) => JetuMapCubit(client: client.value)..init(),
            ),
            BlocProvider(
              create: (context) => CurrentLocationCubit(),
            ),
            BlocProvider(
              create: (context) => OrderCubit(client: client.value),
            ),
          ],
          child: GlobalLoaderOverlay(
            child: GraphQLProvider(
              client: client,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Jetu Taxi',
                home: child,
              ),
            ),
          ),
        );
      },
      child: BlocListener<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state.isLoading) {
              context.loaderOverlay.show(widget: AppOverlayLoader());
            }

            if (!state.isLoading) {
              context.loaderOverlay.hide();
            }
          },
          child: child),
    );
  }
}
