import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/app/view/order/bloc/order_cubit.dart';
import 'package:jetu.driver/app/view/order/bloc/order_state.dart';
import 'package:jetu.driver/app/view/order/order_detail_screen.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet/app_detail_sheet.dart';

class JetuMap extends StatelessWidget {
  final MapController mapController;

  const JetuMap({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, orderState) {
        return BlocBuilder<JetuMapCubit, JetuMapState>(
          builder: (context, state) {
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: state.mapCenter,
                onMapCreated: (MapController controller) async {
                  await mapController.onReady;
                  context.read<JetuMapCubit>()
                    ..nearOrders(mapController.bounds!, orderState.showOrders);
                  mapController.mapEventStream.listen((event) {
                    if (event is MapEventMoveStart) {
                      context.read<JetuMapCubit>()..mapPanning(true);
                    } else if (event is MapEventMoveEnd) {
                      context.read<JetuMapCubit>()..mapPanning(false);
                      context.read<JetuMapCubit>()
                        ..nearOrders(
                            mapController.bounds!, orderState.showOrders);
                    }
                  });
                },
                zoom: 14,
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                plugins: [
                  const LocationMarkerPlugin(),
                ],
              ),
              layers: [
                LocationMarkerLayerOptions(
                    accuracyCircleColor: AppColors.white),
                MarkerLayerOptions(
                  markers: [
                    // if (state.orderList.isNotEmpty && orderState.showOrders)
                    //   for (var k in state.orderList)
                    //     Marker(
                    //       point: k.aPoint(),
                    //       builder: (context) {
                    //         return InkWell(
                    //           onTap: () async {
                    //             bool? isAccepted = await AppDetailSheet.open(
                    //               context,
                    //               widget: OrderDetailScreen(model: k),
                    //             );
                    //
                    //             if (isAccepted ?? false) {
                    //               context.read<OrderCubit>().acceptOrder(k.id);
                    //             }
                    //           },
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //               border: Border.all(),
                    //               color: AppColors.yellow,
                    //               borderRadius: BorderRadius.circular(999),
                    //             ),
                    //             child: Icon(Ionicons.location),
                    //           ),
                    //         );
                    //       },
                    //     ),
                  ],
                ),
              ],
              children: [
                TileLayerWidget(
                  options: AppConst.getMapTile(),
                ),
                LocationMarkerLayerWidget(
                  plugin: const LocationMarkerPlugin(
                    centerOnLocationUpdate: CenterOnLocationUpdate.once,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
