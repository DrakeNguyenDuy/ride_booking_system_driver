import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';

class ButtonStyleHandle {
  static ButtonStyle bts_1 = ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith(
          (states) => ColorPalette.primaryColor));
}
