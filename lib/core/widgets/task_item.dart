import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';

class TaskItem extends StatefulWidget {
  final int tripId;
  final String from;
  final String to;
  final int price;
  final double rating;
  final String customerName;
  final String phoneNumber;
  final String gender;
  const TaskItem(
      {super.key,
      required this.tripId,
      required this.from,
      required this.to,
      required this.price,
      required this.rating,
      required this.customerName,
      required this.phoneNumber,
      required this.gender});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  //render status task

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ds_2 * 1.5),
      margin: const EdgeInsets.only(
          top: ds_1 * 2, bottom: ds_1 * 2, left: ds_1 * 2, right: ds_1 * 2),
      width: 200,
      height: 120,
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
                  widget.from,
                ),
              ),
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  widget.to,
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: ds_2 / 2, bottom: ds_2 / 2),
          //   child: Text(
          //     widget.expriceDate,
          //     textAlign: TextAlign.start,
          //   ),
          // ),
        ],
      ),
    );
  }
}
