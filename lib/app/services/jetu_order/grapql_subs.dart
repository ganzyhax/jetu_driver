class JetuOrderSubscription {
  static String subscribeOrder() {
    return ("""subscription (\$driverId: String!) {
  jetu_orders(where: {driver_id: {_eq: \$driverId},status: {_in: ["onway","arrived","started","paymend","requested"]}}){
    id,
    jetu_user{
      id,
      name,
      phone,
      token,
      avatarUrl
    },
    cost,
    status,
    point_a_lat,
    point_a_long,
    point_b_lat,
    currency
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

  static String queryOrders() {
    return ("""subscription (\$driverId: String!) {
  jetu_orders(where: {driver_id: {_eq: \$driverId},status: {_in: ["onway","arrived","started","paymend","requested"]}}){
    id,
    jetu_user{
      id,
      name,
      phone,
      avatarUrl
    },
    cost,
    status,
    point_a_lat,
    point_a_long,
    point_b_lat,
    point_b_long,
    currency,
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

  static String getIntercityOrders() {
    return ("""
    subscription check_intercity_order(\$start: timestamptz!,\$end: timestamptz!,\$aCity: uuid!,\$bCity: uuid!) {
  jetu_intercity_orders(order_by: {date: asc},where: {date: {_gte: \$start, _lte: \$end},a_city: {_eq: \$aCity},b_city: {_eq: \$bCity},status: {_eq: "finding"},user_id: {_is_null: false}}){
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
    status,
    jetu_user{
      id,
      name,
      surname,
      phone,
      avatarUrl
      
      }
  }
}
    """);
  }

  static String subscribeOrderDetail() {
    return ("""subscription orderDetailCheck(\$orderId: uuid!) {
  jetu_orders(where: {id: {_eq: \$orderId}}){
    id,
    jetu_user{
      id,
      name,
      phone,
      token,
      avatarUrl
    },
    cost,
    jetu_driver{
      id
    },
    status,
    point_a_lat,
    currency,
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
