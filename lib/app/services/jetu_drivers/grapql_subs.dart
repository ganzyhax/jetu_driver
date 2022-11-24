class JetuDriverSubscription {
  static String getDrivers() {
    return ("""query(\$lat: float8,\$long: float8){
  near_drivers(args: {latitude: \$lat,longitude:\$long,distance_kms: 3}){
    id,
    lat,
    long
  }
}
""");
  }
}
