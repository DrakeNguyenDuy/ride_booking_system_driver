import 'package:http/http.dart' as http;
import 'package:ride_booking_system/application/common.config.dart';
import 'package:ride_booking_system/core/constants/url_system.dart';

class PersonService {
  Future<http.Response> getInfo(String id) async {
    var uri = Uri.http(CommonConfig.ipAddress, '$UrlSystem.personal/$id');
    Map<String, String> header =
        CommonConfig.headerWithToken() as Map<String, String>;
    return await http.get(
      uri,
      headers: header,
    );
  }
}
