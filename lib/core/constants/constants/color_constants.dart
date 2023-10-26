import 'package:flutter/cupertino.dart';

class ColorPalette {
  static const Color primaryColor = Color(0xff00305e);
  static const Color secondColor = Color.fromARGB(255, 226, 228, 231);
  static const Color white = Color(0xffffffff);
  static const Color hintColor = Color(0xffC0C8E7);

  static const Color textColor = Color(0xff8C8C8C);
  static const Color blueLightColor = Color.fromARGB(255, 235, 240, 246);
  static const Color grayDrak = Color.fromARGB(255, 197, 197, 197);
  static const Color grayLight = Color.fromARGB(255, 231, 231, 231);
  static const Color pink = Color(0xffC06FEB);
  static const Color green = Color.fromARGB(255, 2, 171, 8);
  static const Color blue = Color.fromARGB(255, 16, 36, 246);
  static const Color yellow = Color.fromARGB(255, 223, 234, 6);
  static const Color red = Color.fromARGB(255, 222, 42, 2);
  static const Color organge = Color.fromARGB(255, 228, 153, 2);
}

class GradientColor {
  static const Gradient defaultGradientBackground = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.topRight,
      colors: [ColorPalette.primaryColor, ColorPalette.secondColor]);
}
