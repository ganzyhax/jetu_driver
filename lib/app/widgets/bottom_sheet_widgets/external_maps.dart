import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetu.driver/app/widgets/bottom_sheet_widgets/bottom_sheet_title.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_launcher/map_launcher.dart';

class ExternalMaps extends StatelessWidget {
  final List<AvailableMap> maps;
  final LatLng location;

  const ExternalMaps({
    Key? key,
    required this.maps,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomSheetTitle(title: "Выберите приложение для навигации"),
        SingleChildScrollView(
          child: Wrap(
            children: <Widget>[
              for (var map in maps)
                ListTile(
                  onTap: () => map.showMarker(
                    coords: Coords(
                      location.latitude,
                      location.longitude,
                    ),
                    title: '',
                  ),
                  title: Text(map.mapName),
                  leading: SvgPicture.asset(
                    map.icon,
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
