import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';

class Category extends StatelessWidget {
  final String pathImage;
  final Color color1;
  final Color color2;
  final String nameCategory;
  final bool hasWaterMask;
  const Category(
      {super.key,
      required this.pathImage,
      required this.color1,
      required this.color2,
      required this.nameCategory,
      required this.hasWaterMask});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 180,
      // padding: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxHeight: double.infinity),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: color1,
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 5,
              color: ColorPalette.white.withOpacity(0.5))
        ],
      ),
      child: Stack(children: [
        Positioned(
            right: -20,
            top: -20,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(-30 / 360),
              child: Image.asset(
                hasWaterMask ? AssetImages.starW : AssetImages.starW,
                scale: 4,
                color: ColorPalette.secondColor
                    .withOpacity(hasWaterMask ? 0.5 : 0),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 0, 15),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: ColorPalette.grayDrak),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Image.asset(
                    pathImage,
                    scale: 2,
                  ),
                ),
                Text(
                  "1",
                  style: TextStyleApp.ts_1.copyWith(color: color2),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: SizedBox(
                  height: 75,
                  child: Text(
                    nameCategory,
                    style: TextStyleApp.tsHeader.copyWith(color: color2),
                  )),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 0),
            //   child: Text(
            //     subDesriptions,
            //     style: TextStyleApp.ts_1.copyWith(fontSize: 10),
            //   ),
            // ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                    onPressed: null,
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    icon: Icon(
                      Icons.arrow_right_alt_rounded,
                      color: color2,
                      size: 30,
                    ),
                    label: Text(
                      "Xem ngay",
                      style: TextStyle(color: color2),
                    ))
              ],
            ))
          ]),
        ),
      ]),
    );
  }
}
