import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

class AppConst {
  static const appStoreId = '1645351907';
  static const playMarketId = 'kz.jetutaxi.driver';

  static const hasuraHttpPoint =
      'https://qrtfksgopyjyhsorqtpq.nhost.run/v1/graphql';

  static const hasuraWebSocketPoint =
      'wss://qrtfksgopyjyhsorqtpq.nhost.run/v1/graphql';

  static const hasuraKey = {
    'x-hasura-admin-secret': '06d6dc747237967080c19d6b830f89d7',
  };

  static const String loginTermsAndConditionsUrl =
      "https://www.freeprivacypolicy.com/privacy/view/ff8fed2dd3b1f40c3df93ac707d2ecb4";

  static const String supaUrl = 'https://kwduzpdsgybockrbefnz.supabase.co';
  static const String supaKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3ZHV6cGRzZ3lib2NrcmJlZm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjU1MDcxMjcsImV4cCI6MTk4MTA4MzEyN30.Z0bF8CU_jl-M6ZRlML6GU0SCp7AYdA9LUv1WnxzB4qQ';

  static const appZCloudKey = 'io6OQaSlxGPMazCkdfaVISLUnVp2M2q1';
  static const String mapBoxAccessToken =
      "pk.eyJ1IjoiemhhaWdnIiwiYSI6ImNsOGE5dWN5MDBlczQzb250MW5tNW45bWkifQ.N0u0B0-ieiNn4nx9f1fU2Q";

  static const whatsAppSupport = 'whatsapp://send?phone=77058895658';
  static const instagramAppSupport = 'https://instagram.com/hacker.atyrau';

  static TileLayerOptions getMapTile() {
    // if (kReleaseMode) {
    //   return TileLayerOptions(
    //     urlTemplate:
    //         "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=$mapBoxAccessToken",
    //     additionalOptions: {"access_token": mapBoxAccessToken,},
    //     maxNativeZoom: 18,
    //   );
    // }
    return TileLayerOptions(
      urlTemplate: "https://mt0.google.com/vt/lyrs=m@221097413&x={x}&y={y}&z={z}",
      subdomains: ['a', 'b', 'c'],
      maxNativeZoom: 18,
      retinaMode: true,
    );
  }
}
