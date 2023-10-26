import 'package:flutter/material.dart';
import 'package:ride_booking_system/core/constants/constants/assets_font.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system/core/constants/constants/font_size_constanst.dart';

//đang viết chức năng check kiểm tra đầu vào của giá trị còn đang lở dở
class InputLable extends StatelessWidget {
  final String? nameLable;
  final bool typePassword;
  final TextEditingController? controller;
  const InputLable(
      {super.key,
      @required this.nameLable,
      this.typePassword = false,
      @required this.controller});
  String checkEmailValidFormat(value) {
    print("hello " + value);
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          nameLable!,
          style: TextStyle(
            color: ColorPalette.primaryColor,
            fontSize: fs_2,
            fontWeight: FontWeight.w600,
            fontFamily: AssetsFont.fontMonterrat,
          ),
        ),
        TextFormField(
          validator: (value) => checkEmailValidFormat(value),
          controller: controller,
          obscureText: typePassword,
          decoration: InputDecoration(
            hintText: "Youremail@gmail.com",
            hintStyle: TextStyle(
                color: ColorPalette.blueLightColor,
                fontSize: fs_1,
                fontWeight: FontWeight.w300,
                fontFamily: AssetsFont.fontMonterrat),
            filled: true,
            fillColor: ColorPalette.blueLightColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(style: BorderStyle.none)),
          ),
        ),
      ],
    );
  }
}
