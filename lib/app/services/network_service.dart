import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jetu.driver/app/const/app_const.dart';
import 'package:jetu.driver/data/model/place_item.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_api/mapbox_api.dart';
import 'package:polyline_do/polyline_do.dart';
import 'package:supabase/supabase.dart';

class NetworkService {
  static final client = SupabaseClient(AppConst.supaUrl, AppConst.supaKey);
  static final config = {"zkey": AppConst.appZCloudKey};

  static Future<List<Feature>> placeAutocomplete({
    required String text,
  }) async {
    try {
      var coordinate = await Geolocator.getCurrentPosition();

      final searchQuery = {
        'q': text,
        'lat': coordinate.latitude.toString(),
        'lon': coordinate.longitude.toString(),
        'limit': '7',
      };

      var response = await http.Client().get(
        Uri.https('photon.komoot.io', '/api', searchQuery),
      );
      await client.from('search-service').insert(config).execute();
      List<Feature> sortedItem = [];

      for (Feature i in placeFromJson(response.body).features ?? []) {
        if (i.properties?.osmKey == 'building') {
          sortedItem.add(i);
        }
      }

      return sortedItem;
    } catch (err) {
      print('placeAutocompleteError: $err');
      return [];
    }
  }

  static Future<List<LatLng>> requestPathFromMapBox(
      List<List<double>> list) async {
    try {
      MapboxApi mapbox = MapboxApi(
        accessToken: AppConst.mapBoxAccessToken,
      );

      DirectionsApiResponse response = await mapbox.directions.request(
        overview: NavigationOverview.FULL,
        profile: NavigationProfile.DRIVING,
        geometries: NavigationGeometries.POLYLINE,
        steps: true,
        coordinates: list,
      );

      await client.from('route-service').insert(config).execute();

      if (response.error != null) {
        if (response.error is NavigationNoRouteError) {
          print(response.error);
        } else if (response.error is NavigationNoSegmentError) {
          print(response.error);
        }
        return [];
      }

      if (response.routes?.isNotEmpty ?? false) {
        final route = response.routes![0];
        final polyline = Polyline.Decode(
          encodedString: route.geometry,
          precision: 5,
        );

        final coordinates = polyline.decodedCoords;
        final path = <LatLng>[];

        for (var i = 0; i < coordinates.length; i++) {
          path.add(
            LatLng(
              coordinates[i][0],
              coordinates[i][1],
            ),
          );
        }

        return path;
      }
      return [];
    } catch (err) {
      print('pathReqError: $err');
      return [];
    }
  }

// static Future<List<LatLng>> routeDirection({
//   required LatLng aPointV,
//   required LatLng bPointV,
// }) async {
//   try {
//     final routeQuery = {
//       'overview': 'false',
//       'alternatives': 'false',
//       'steps': 'true',
//     };
//
//     String aPoint = '${aPointV.latitude},${aPointV.longitude}';
//     String bPoint = '${bPointV.latitude},${bPointV.longitude}';
//     String direction = '$aPoint;$bPoint';
//
//     var response = await http.Client().get(
//       Uri.https(
//         'routing.openstreetmap.de',
//         '/routed-car/route/v1/driving/41.65367024330191,41.63929816912619;41.64692604689595,41.630665036625714',
//         routeQuery,
//       ),
//     );
//     List<LatLng> sortedItem = [];
//
//     if (response.statusCode.toString().startsWith('2')) {
//       RouteItem routeItem = routeItemFromJson(response.body);
//
//       for (Step routes in routeItem.routes?.first.legs?.first.steps ?? []) {
//         sortedItem.add(
//           LatLng(
//             routes.maneuver?.location?.first ?? 0.0,
//             routes.maneuver?.location?.last ?? 0.0,
//           ),
//         );
//       }
//     }
//
//     print(sortedItem.length);
//     for(var ad in sortedItem){
//       print('${ad.latitude}, ${ad.longitude}');
//     }
//     return sortedItem;
//   } catch (err) {
//     print('routeDirection: $err');
//     return [];
//   }
// }

}
