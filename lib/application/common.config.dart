import 'package:ride_booking_system/core/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonConfig {
  static String ipAddress = "ridebookingsystem.ddns.net:9090";
  static String API_GOOGLE_KEY = "AIzaSyBCGvOLZ6WHQRTeoyzjbKqw4j2OW9-5akU";
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
