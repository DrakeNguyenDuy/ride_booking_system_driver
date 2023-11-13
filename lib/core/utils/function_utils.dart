import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';

class FunctionUtils {
  static final PersonService _personalService = PersonService();
  static void connect(int idUser) async {
    _personalService.connect(idUser).then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        Fluttertoast.showToast(
            msg: "Kết nối thành công", webPosition: "bottom");
      } else {
        Fluttertoast.showToast(msg: "Đã xảy ra lỗi", webPosition: "bottom");
      }
    });
  }
}
