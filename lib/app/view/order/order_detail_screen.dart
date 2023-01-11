import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:jetu.driver/app/di/injection.dart';
import 'package:jetu.driver/app/extensions/context_extensions.dart';
import 'package:jetu.driver/app/resourses/app_colors.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_cubit.dart';
import 'package:jetu.driver/app/view/home/widgets/jetu_map/bloc/jetu_map_state.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v1.dart';
import 'package:jetu.driver/app/widgets/button/app_button_v2.dart';
import 'package:jetu.driver/app/widgets/list_item/order_item.dart';
import 'package:jetu.driver/data/model/jetu_order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final JetuOrderModel model;

  const OrderDetailScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: AppColors.black,
                ),
                Text('назад')
              ],
            ),
          ),
          SizedBox(height: 12.h),
          BlocProvider(
            create: (context) => JetuMapCubit(
              client: injection(),
            )..onDetailView(model),
            child: BlocBuilder<JetuMapCubit, JetuMapState>(
              builder: (context, state) {
                return SizedBox(
                  height: context.sizeScreen.height * 0.35,
                  child: FlutterMap(
                    options: MapOptions(
                      center: model.aPoint(),
                      zoom: 13,
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                      plugins: [
                        const LocationMarkerPlugin(),
                      ],
                    ),
                    children: [
                      LocationMarkerLayerWidget(
                        plugin: const LocationMarkerPlugin(
                          centerOnLocationUpdate: CenterOnLocationUpdate.once,
                        ),
                      ),
                    ],
                    layers: [
                      LocationMarkerLayerOptions(
                          accuracyCircleColor: AppColors.white),
                      TileLayerOptions(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        retinaMode: true,
                      ),
                      PolylineLayerOptions(
                        polylines: [
                          Polyline(
                            points: state.route,
                            strokeWidth: 5,
                            color: AppColors.black.withOpacity(0.6),
                          )
                        ],
                      ),
                      MarkerLayerOptions(
                        markers: [
                          if (state.points.isNotEmpty)
                            for (var k in state.points)
                              Marker(
                                point: k,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: AppColors.blue,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Icon(Ionicons.location),
                                  );
                                },
                              ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    OrderItem(model: model),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: AppButtonV1(
                        text: 'Принять заказ',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: AppButtonV2(
                        text: 'Пропустить',
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
