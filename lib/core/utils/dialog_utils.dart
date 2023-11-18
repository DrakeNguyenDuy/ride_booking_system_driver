import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';

class DialogUtils {
  static void showDialogNotfication(
      BuildContext context, bool isError, String message, IconData icon) {
    Widget okButton = TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith(
            (states) => ColorPalette.primaryColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        "OK",
        style: TextStyle(color: ColorPalette.white),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: Text(isError ? "Lỗi" : "Chúc mừng",
                style: const TextStyle(fontSize: 25)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: message,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16)),
                ),
              ],
            ),
            actions: [okButton],
            actionsAlignment: MainAxisAlignment.spaceAround,
            icon: Icon(icon,
                size: 50,
                color: isError ? ColorPalette.red : ColorPalette.green),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          );
        });
  }
}
