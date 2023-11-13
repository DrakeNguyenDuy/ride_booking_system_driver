class UrlSystem {
  static String api = "/api";
  static String auth = "$api/auth";
  static String singin = "$auth/signin";

  static String personal = "$api/person";
  static String trip = "/trip";
  static String connect = "${trip}/connect";
  static String disconnect = "${trip}/disconnect";
  static String updatePersonal = '$personal/update';
  static String history = '$trip/driver';
  static String accecpRide = '$trip/acceptRide';
}
