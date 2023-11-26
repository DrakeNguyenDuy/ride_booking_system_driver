import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonConfig {
  static String ipAddress = "ridebookingsystem.ddns.net:9090";
  static String endPointSocket = "${ipAddress}/myhandler";
  static String API_GOOGLE_KEY = "AIzaSyA7Rsy3zO2ELMAYQ4uDbopnU6GWLg7vMg8";
  static Map<String, String> header = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  static Future<Map<String, String>> headerWithToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.get(Varibales.ACCESS_TOKEN);
    return header = {
      "content-type": "application/json",
      "accept": "application/json",
      'Authorization': 'Bearer $token'
    };
  }
}
