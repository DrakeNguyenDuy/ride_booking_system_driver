import 'package:flutter/material.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system/core/style/text_style.dart';

class CategoryItem extends StatelessWidget {
  final String pathFile;
  final String nameCategoryItem;
  const CategoryItem(
      {super.key, required this.pathFile, required this.nameCategoryItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      splashColor: ColorPalette.primaryColor.withOpacity(0.1),
      onTap: (() => {}),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border: Border.all(color: ColorPalette.grayDrak),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                pathFile,
                scale: 1.5,
              ),
              Text(
                nameCategoryItem,
                style: TextStyleApp.ts_1.copyWith(fontSize: 12),
              )
            ]),
      ),
    );
  }
}
