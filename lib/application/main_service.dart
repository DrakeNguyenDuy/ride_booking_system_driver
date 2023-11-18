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

  Future<String> pickUpCustomer(String tripId) async {
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'http://ridebookingsystem.ddns.net:9090/trip/pickupCustomer'));
    request.fields.addAll({'tripId': tripId});
    request.headers.addAll(header);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return respStr;
  }

  Future<String> conpleteTrip(String tripId) async {
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    var request = http.MultipartRequest('GET',
        Uri.parse('http://ridebookingsystem.ddns.net:9090/trip/completeRide'));
    request.fields.addAll({'tripId': tripId});
    request.headers.addAll(header);
    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    return respStr;
  }
}
