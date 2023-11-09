import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ride_booking_system_driver/application/common.config.dart';
import 'package:ride_booking_system_driver/core/constants/url_system.dart';

class PersonService {
  Future<http.Response> connect(int driverId) async {
    var uri = Uri.http(CommonConfig.ipAddress, UrlSystem.connect);
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    final body = jsonEncode({"userId": driverId});
    return await http.post(uri, headers: header, body: body);
  }

  Future<http.Response> disconnect(int driverId) async {
    var uri = Uri.http(CommonConfig.ipAddress, UrlSystem.disconnect);
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    final body = jsonEncode({"userId": driverId});
    return await http.post(uri, headers: header, body: body);
  }

  Future<http.Response> editPersonal(String name, String gender,
      String phoneNumber, String address, int userId) async {
    var uri = Uri.http(CommonConfig.ipAddress, UrlSystem.updatePersonal);
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    final body = jsonEncode({
      "address": address,
      "gender": gender,
      "name": name,
      "userId": userId,
      "phoneNumber": phoneNumber,
      "userModel": {"userId": userId}
    });
    return await http.post(uri, headers: header, body: body);
  }
}
