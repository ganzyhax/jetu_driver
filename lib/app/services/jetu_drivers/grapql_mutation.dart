class JetuDriverMutation {
  static String updateLocation() {
    return ("""mutation update_location(\$userId: String!, \$lat: float8!, \$long: float8!) {
  update_jetu_drivers_by_pk(pk_columns: {id: \$userId}, _set: {lat: \$lat, long: \$long}) {
    id
  }
}
""");
  }

  static String addDriverBalance() {
    return ("""
      mutation update_is_free(\$driverId: String!, \$amount: Float!) {
        update_jetu_drivers_by_pk(pk_columns: {id: \$driverId}, _set: {amount: \$amount, is_background: false}) {
          id
        }
      }
    """);
  }

  static String updateUserImage() {
    return ("""
      mutation update_avatar_url(\$driverId: String!, \$avatar_url: String!) {
        update_jetu_drivers_by_pk(pk_columns: {id: \$driverId}, _set: {avatar_url: \$avatar_url}) {
          id
        }
      }
    """);
  }

  static String updateUserFreeStatus() {
    return ("""
      mutation update_is_free(\$userId: String!, \$value: Boolean!) {
        update_jetu_drivers_by_pk(pk_columns: {id: \$userId}, _set: {is_free: \$value, is_background: false}) {
          id
        }
      }
    """);
  }

  static String updateUserIsBackground() {
    return ("""
      mutation update_is_background(\$userId: String!, \$value: Boolean!) {
        update_jetu_drivers_by_pk(pk_columns: {id: \$userId}, _set: {is_background: \$value}) {
          id
        }
      }
    """);
  }

  static String updateUserToken() {
    return ("""
      mutation update_token(\$userId: String!, \$value: String!) {
        update_jetu_drivers_by_pk(pk_columns: {id: \$userId}, _set: {token: \$value}) {
          token
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

  static String createTransaction() {
    return ("""mutation create_transaction(\$object: transaction_insert_input!){
  insert_transaction_one(object: \$object){
    id
  }
}
""");
  }

  static String insertDriverDate() {
    return ("""mutation create_user(\$object: jetu_drivers_insert_input!){
  insert_jetu_drivers_one(object: \$object){
    id
  }
}
""");
  }

  static String insertDriverDocImages() {
    return ("""mutation create_driver_docs(\$object: jetu_driver_documents_insert_input!){
  insert_jetu_driver_documents_one(object: \$object){
    id
  }
}
""");
  }
}
