class JetuOrdersQuery {
  static String fetchOrders() {
    return ("""subscription (\$xmax: float8,\$xmin: float8,\$ymax: float8,\$ymin: float8){
  orders_by_bound(args: {xxmax: \$xmax, xxmin:\$xmin, yymax: \$ymax,yymin: \$ymin}){
    id,
    jetu_user{
      id,
      name
    },
    cost,
    comment,
    created_at,
    status,
    point_a_lat,
    point_a_long,
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
