import 'package:flutter/material.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system/core/constants/constants/dimension_constanst.dart';

//đang viết chức năng check kiểm tra đầu vào của giá trị còn đang lở dở
// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  final String nameLable;
  final bool typePassword;
  final IconData? iconData;
  final TextEditingController? controller;
  const TextFieldWidget(
      {super.key,
      required this.nameLable,
      this.typePassword = false,
      this.controller,
      this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ds_1),
      child: TextField(
          obscureText: typePassword,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: iconData != null ? Icon(iconData) : null,
            hintText: nameLable,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(ds_3)),
              borderSide:
                  BorderSide(width: ds_0, color: ColorPalette.primaryColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(ds_3)),
              borderSide:
                  BorderSide(width: ds_0, color: ColorPalette.primaryColor),
            ),
          )),
    );
  }
}
