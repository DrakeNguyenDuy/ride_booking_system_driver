import 'package:http/http.dart' as http;
import 'package:ride_booking_system_driver/application/common.config.dart';

class GoogleService {
  Future<http.Response> getDistance(double latitudePick, double longtidudePick,
      double latitudeDes, double longtidudeDes) async {
    String path = "https://maps.googleapis.com/maps/api/distancematrix/"
        "json?destinations=$latitudePick%2C$longtidudePick&"
        "origins=$latitudeDes%2C$longtidudeDes&key=${CommonConfig.API_GOOGLE_KEY}";
    print(path);
    var uri = Uri.http(path);
    return await http.get(uri);
  }
}
