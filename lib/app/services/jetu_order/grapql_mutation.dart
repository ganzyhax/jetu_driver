class JetuOrderMutation {
  static String acceptOrder() {
    return ("""mutation accept_order(\$orderId: uuid!,\$driverId: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
  	_set: { driver_id: \$driverId, status: "onway"}
  ){
    status
  }
}
""");
  }

  static String updateStatusOrder() {
    return ("""mutation update_order_status(\$orderId: uuid!,\$status: String!){
  update_jetu_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { status: \$status }
  ){
    status
  }
}
""");
  }

  static String updateStatusIntercityOrder() {
    return ("""mutation update_order_status(\$orderId: uuid!,\$status: String!){
  update_jetu_intercity_orders_by_pk(
    pk_columns: {id: \$orderId}
    _set: { status: \$status }
  ){
    status
  }
}
""");
  }
}
