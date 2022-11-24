class JetuAuthQuery {
  static String isRegistered() {
    return ("""query check_driver_login(\$phone: String!){
  jetu_drivers (where: {phone: {_like: \$phone}}){
    status
  }
}
""");
  }

  static String checkStatus() {
    return ("""query check_driver_status(\$userId: String!){
  jetu_drivers_by_pk (id: \$userId){
    status
  }
}
""");
  }

  static String fetchUserInfo() {
    return ("""query fetch_user_info(\$userId: String!){
  jetu_drivers_by_pk(id: \$userId) {
    id,
    name,
    surname,
    phone,
    email
  }
}
""");
  }
}
