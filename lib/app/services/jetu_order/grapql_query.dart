class JetuOrdersQuery {
  static String fetchOrders() {
    return ("""subscription (\$lat: float8,\$lon: float8){
  order_by_location(args: {lat: \$lat, lon: \$lon}){
    id,
    jetu_user{
      id,
      name,
      token,
      avatarUrl
    },
    cost,
    comment,
    created_at,
    status,
    point_a_lat,
    point_a_long,
    currency,
    point_b_lat,
    point_b_long,
    point_a_address,
    point_b_address,
    jetu_service{
      id,
      title
    }
  }
}
""");
  }
}
