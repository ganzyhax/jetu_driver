class JetuOrderSubscription {
  static String subscribeOrder() {
    return ("""subscription (\$driverId: String!) {
  jetu_orders(where: {driver_id: {_eq: \$driverId},status: {_in: ["onway","arrived","started","paymend"]}}){
    id,
    jetu_user{
      id,
      name,
      phone,
    },
    cost,
    status,
    point_a_lat,
    point_a_long,
    point_b_lat,
    point_b_long,
    created_at,
    comment,
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
