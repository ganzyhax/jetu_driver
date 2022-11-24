class JetuAuthMutation {
  static String insertDriverDate() {
    return ("""mutation create_user(\$object: jetu_drivers_insert_input!){
  insert_jetu_drivers_one(object: \$object){
    id
  }
}
""");
  }

  // {
  // "userId": "sdd",
  // "name": "",
  // "surname": "",
  // "carModel": "",
  // "carColor": "",
  // "carNumber": ""
  // }
  static String updateDriverData() {
    return ("""mutation update_user(\$userId: String!,\$name: String!,\$surname: String!, \$email: String!){
  update_jetu_users_by_pk(pk_columns: {id: \$userId}
    _set: {name: \$name,surname: \$surname,email: \$email}){
    id
  }
}
""");
  }
}
