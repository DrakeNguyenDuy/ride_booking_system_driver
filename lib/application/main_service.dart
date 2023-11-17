import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_booking_system_driver/application/common.config.dart';
import 'package:ride_booking_system_driver/core/constants/url_system.dart';

class MainService {
  Future<http.Response> cancelRide(int tripId, String reason) async {
    var uri = Uri.http(CommonConfig.ipAddress, UrlSystem.cancelRide);
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    final body = jsonEncode({"tripId": tripId, "reason": reason});
    return await http.post(uri, headers: header, body: body);
  }
}
