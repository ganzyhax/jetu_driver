class JetuDriverMutation {
  static String updateLocation() {
    return ("""mutation update_location(\$userId: String!,\$lat: float8!,\$long: float8!){
  update_jetu_drivers_by_pk(pk_columns: {id: \$userId}_set: {lat: \$lat,long: \$long}){
    id
  }
}
""");
  }

  static String createIntercityPost() {
    return ("""mutation create_intercity_post(\$object: jetu_intercity_orders_insert_input!){
  insert_jetu_intercity_orders_one(object: \$object){
    id
  }
}
""");
  }
}
