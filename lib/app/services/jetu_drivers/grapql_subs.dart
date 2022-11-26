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

  static String getDriverOrderHistory() {
    return ("""query (\$driverId: String!){
  jetu_orders(where: {driver_id: {_eq: \$driverId}}){
    id,
    point_a_address,
    point_b_address
    cost,
    currency,
    comment,
    status,
    created_at
  }
}
""");
  }
}
