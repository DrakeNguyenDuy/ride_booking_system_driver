import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';

class AppBarCustomize extends StatelessWidget implements PreferredSizeWidget {
  final String nameTitle;
  final IconData? iconLeading;
  final List<String>? iconOptions; //list icon on right app bar
  const AppBarCustomize(
      {super.key, required this.nameTitle, this.iconLeading, this.iconOptions});

  void backScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: () => backScreen(context),
          child: Icon(
            iconLeading,
            size: sizeIcon_1,
            color: ColorPalette.primaryColor,
          )),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nameTitle,
            style: TextStyleApp.tsHeader,
            textAlign: TextAlign.center,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: iconOptions == null
                  ? []
                  : iconOptions!
                      .map(
                        (item) => SizedBox(
                          width: 40,
                          height: 40,
                          child: TextButton(
                              onPressed: null, child: Image.asset(item)),
                        ),
                      )
                      .toList())
        ],
      ),
      backgroundColor: ColorPalette.white,
      shadowColor: ColorPalette.primaryColor.withOpacity(0.1),

      // bottom: TabBar(
      //   labelColor: ColorPalette.primaryColor,
      //   labelStyle: TextStyle(color: ColorPalette.primaryColor),
      //   controller: _tabController,
      //   tabs: listTab,
      // )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
