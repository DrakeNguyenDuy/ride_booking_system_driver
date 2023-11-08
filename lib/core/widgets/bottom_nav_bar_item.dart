import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';

class BottomNavBarItem extends StatefulWidget {
  final int indexItem;
  final IconData icon;
  final String nameItem;
  final int currentIndex;
  final Function changeIndexCurrnt;
  const BottomNavBarItem(
      {super.key,
      required this.indexItem,
      required this.icon,
      required this.nameItem,
      required this.currentIndex,
      required this.changeIndexCurrnt});

  @override
  State<BottomNavBarItem> createState() => _BottomNavBarItemState();
}

class _BottomNavBarItemState extends State<BottomNavBarItem> {
  late bool selected;
  @override
  void initState() {
    super.initState();
    selected = widget.currentIndex == widget.indexItem;
  }

  @override
  void didUpdateWidget(covariant BottomNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.currentIndex == widget.indexItem;
  }

  void tapItem() {
    widget.changeIndexCurrnt(widget.indexItem, widget.nameItem);
    // setState(() {
    //   selected = !selected;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: tapItem,
        hoverColor: ColorPalette.green,
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: selected ? const Alignment(0, -50) : Alignment.center,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              child: Icon(
                widget.icon,
                color: ColorPalette.white,
                size: 30,
              ),
            ),
            AnimatedAlign(
              curve: Curves.fastOutSlowIn,
              alignment: selected ? Alignment.center : const Alignment(0, 50),
              duration: const Duration(milliseconds: 500),
              child: Text(
                widget.nameItem,
                style: TextStyleApp.ts_1
                    .copyWith(color: ColorPalette.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// AnimatedAlign(
//             alignment: selected ? Alignment(0, -50) : Alignment.center,
//             curve: Curves.fastOutSlowIn,
//             duration: Duration(milliseconds: 500),
//             child: selected
//                 ? AnimatedAlign(
//                     alignment: Alignment(0, 50),
//                     duration: Duration(milliseconds: 500),
//                     child: Text("Home"),
//                   )
//                 : Icon(
//                     widget.icon,
//                     color: ColorPalette.white,
//                     size: 38,
//                   ))