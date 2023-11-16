import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';

class TaskItem extends StatefulWidget {
  final int tripId;
  final String from;
  final String to;
  final int price;
  final double rating;
  final String driverName;
  final String phoneNumber;
  final String gender;
  const TaskItem(
      {super.key,
      required this.tripId,
      required this.from,
      required this.to,
      required this.price,
      required this.rating,
      required this.driverName,
      required this.phoneNumber,
      required this.gender});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  //render status task
  final sizeBox = SizedBox(
    height: ds_2,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ds_2 * 1.5),
      margin: const EdgeInsets.only(
          top: ds_1 * 2, bottom: ds_1 * 2, left: ds_1 * 2, right: ds_1 * 2),
      width: 200,
      height: 160,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
                color: ColorPalette.primaryColor.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 1)
          ],
          color: ColorPalette.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "Điểm đón: ${widget.from}",
                  style: MainStyle.textStyle3.copyWith(
                    fontSize: fs_2,
                  ),
                ),
              ),
            ],
          ),
          sizeBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "Điểm trả:   ${widget.to}",
                  style: MainStyle.textStyle3.copyWith(fontSize: fs_2),
                ),
              ),
            ],
          ),
          sizeBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Tài xế: ",
                          children: [TextSpan(text: widget.driverName)],
                          style: MainStyle.textStyle3.copyWith(
                              fontSize: fs_2,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)))),
              Flexible(
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: "SĐT: ",
                        children: [TextSpan(text: widget.phoneNumber)],
                        style: MainStyle.textStyle3.copyWith(
                            fontSize: fs_2,
                            color: Colors.black,
                            fontWeight: FontWeight.normal))),
              ),
            ],
          ),
          sizeBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Đánh giá: ",
                          children: [TextSpan(text: '${widget.rating}')],
                          style: MainStyle.textStyle3.copyWith(
                              fontSize: fs_2,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)))),
            ],
          ),
          sizeBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: "Giá: ",
                          children: [
                            TextSpan(text: '${widget.price}'),
                            const TextSpan(text: ' VND')
                          ],
                          style: MainStyle.textStyle3.copyWith(
                              fontSize: fs_2,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)))),
            ],
          ),
        ],
      ),
    );
  }
}
