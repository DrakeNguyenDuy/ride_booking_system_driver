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

  Future<http.Response> getHistory(int driverId) async {
    var uri =
        Uri.http(CommonConfig.ipAddress, "${UrlSystem.history}/$driverId");
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    return await http.get(uri, headers: header);
  }

  Future<http.Response> accecptRide(
      int driverId, String token, int tripId) async {
    var uri = Uri.http(CommonConfig.ipAddress, UrlSystem.accecpRide);
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    final body = jsonEncode(
        {"driverId": driverId, "tokenDriver": token, "tripId": tripId});
    return await http.post(uri, headers: header, body: body);
  }

  Future<http.StreamedResponse> uploadImage(String path, int personId) async {
    Map<String, String> header =
        await CommonConfig.headerWithToken().then((value) => value);
    var request = http.MultipartRequest('POST',
        Uri.parse('http://ridebookingsystem.ddns.net:9090/api/upload-images'));
    request.fields.addAll({'userId': '10'});
    request.files.add(await http.MultipartFile.fromPath('image', path));
    request.headers.addAll(header);
    return await request.send();
  }
}
