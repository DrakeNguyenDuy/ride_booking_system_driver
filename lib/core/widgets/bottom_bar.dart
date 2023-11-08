import 'package:flutter/cupertino.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/init/main_screen_init.dart';
import 'package:ride_booking_system_driver/core/widgets/bottom_nav_bar_item.dart';

class BottomBar extends StatefulWidget {
  final int indexCurrentParameter;
  final Function moveStack;
  const BottomBar(
      {super.key,
      required this.indexCurrentParameter,
      required this.moveStack});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _curentIndex;
  @override
  void initState() {
    super.initState();
    _curentIndex = widget.indexCurrentParameter;
  }

  //update index current in bottom nav bar
  void _changeIndexCurrent(int index, String nameItem) {
    setState(() {
      _curentIndex = index;
    });
    widget.moveStack(index, nameItem);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: const BorderRadius.only(
      //     topLeft: Radius.circular(borderRadiusBigger),
      //     topRight: Radius.circular(borderRadiusBigger)),
      child: Container(
        color: ColorPalette.primaryColor,
        height: MediaQuery.of(context).size.height / 12,
        child: Row(
            children: listItemNavbar
                .map((item) => BottomNavBarItem(
                    indexItem: listItemNavbar.indexOf(item),
                    icon: item.icon,
                    nameItem: item.nameItem,
                    currentIndex: _curentIndex,
                    changeIndexCurrnt: (index, nameItem) =>
                        _changeIndexCurrent(index, nameItem)))
                .toList()),
      ),
    );
  }
}
