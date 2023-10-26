import 'package:flutter/material.dart';

class HandleMessage {
  void showToast(BuildContext context, String? message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      content: Text(message!),
      action: SnackBarAction(
        onPressed: () => scaffold.hideCurrentMaterialBanner(),
        label: 'Ok',
      ),
    ));
  }
}
