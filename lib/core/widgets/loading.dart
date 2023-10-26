import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//đang viết chức năng check kiểm tra đầu vào của giá trị còn đang lở dở
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              Expanded(
                  child: Lottie.asset(
                      "assets/images/imagejson/flash_screen.json")),
            ],
          ),
        )
      ],
    );
  }
}
