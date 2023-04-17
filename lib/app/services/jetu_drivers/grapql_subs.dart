class JetuDriverSubscription {
  static String getDriverAmount() {
    return ("""subscription getDriverAmount(\$driverId: String!) {
  jetu_drivers_by_pk(id: \$driverId){
    amount
  }
}
""");
  }

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
  jetu_orders(where: {driver_id: {_eq: \$driverId}},order_by: {created_at: desc}){
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

  static String getCity() {
    return ("""query (\$query: String!){
  jetu_city(
    where: {title: {_like: \$query}}
  ) {
    id
    title,
    address
  }
}
""");
  }

  static String getIntercityOrders() {
    return ("""subscription check_intercity_order(\$driverId: String!) {
  jetu_intercity_orders(order_by: {date: asc},where: {driver_id: {_eq: \$driverId},status: {_eq: "finding"}}){
    id,
    jetu_city{
      id,
      title
    },
    a_address,
    jetuCityByBCity{
      id,
      title
    },
    b_address,
    price,
    comment,
    date,
    time,
    status
  }
}
""");
  }

  static String getDriverTransactionHistory() {
    return ("""query (\$driverId: String!){
  transaction(where: {driver_id: {_eq: \$driverId}},order_by: {created_at: desc}){
    id,
    amount,
    type,
    created_at
  }
}
""");
  }
}
