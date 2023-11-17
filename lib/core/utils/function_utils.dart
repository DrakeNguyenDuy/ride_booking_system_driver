import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    changeStateConnect(true);
  }

  static void changeStateConnect(bool status) async {
    await SharedPreferences.getInstance().then((ins) {
      ins.setBool(Varibales.IS_CONNECT, status);
    });
  }
}
