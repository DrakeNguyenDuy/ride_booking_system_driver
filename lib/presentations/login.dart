// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:ride_booking_system_driver/application/authentication_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/widgets/text_field_widget.dart';
import 'package:ride_booking_system_driver/presentations/main_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  AuthenticationService authenticationService = AuthenticationService();
  @override
  void initState() {
    super.initState();
  }

  void stop(String message) {
    LoadingProgress.stop(context);
    Fluttertoast.showToast(
        backgroundColor: Colors.amberAccent, msg: message, webPosition: "top");
  }

  void _loggin() async {
    LoadingProgress.start(context);
    var username = userNameController.text;
    var password = passwordController.text;
    authenticationService.login(username, password).then((res) async {
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        String statusCode = body['status'];
        if (statusCode.compareTo("ERROR") == 0) {
          stop(body['data']['message']);
        }
        var userInfo = body['data']['userInfo'];
        String role = userInfo["roleModel"]["name"];
        if (role != Varibales.ROLE_DRIVER) {
          stop(Varibales.YOU_ARE_NOT_A_DRIVER);
        }
        await SharedPreferences.getInstance().then((ins) {
          ins.setString(Varibales.ACCESS_TOKEN, body['data']['accessToken']);
          ins.setInt(Varibales.DRIVER_ID, userInfo["personModel"]["userId"]);
          ins.setString(Varibales.NAME_USER, userInfo["personModel"]["name"]);
          ins.setString(
              Varibales.GENDER_USER, userInfo["personModel"]["gender"]);
          ins.setString(Varibales.PHONE_NUMBER_USER,
              userInfo["personModel"]["phoneNumber"]);
          ins.setString(
              Varibales.AVATAR_USER, userInfo["personModel"]["avatar"]);
          ins.setString(Varibales.ADDRESS, userInfo["personModel"]["address"]);
          ins.setString(Varibales.EMAIL, userInfo["personModel"]["email"]);
          ins.setBool(Varibales.IS_CONNECT, false);
        });
        LoadingProgress.stop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainApp()),
            (route) => false);
      } else {
        LoadingProgress.stop(context);
        Fluttertoast.showToast(
            msg: "Tên đăng nhập hoặc mật khẩu không đúng!", webPosition: "top");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorPalette.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    AssetImages.login,
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Đăng Nhập Tài Xế",
                      style: MainStyle.textStyle1.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: fs_3 * 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFieldWidget(
                      nameLable: "Tên đăng nhập",
                      controller: userNameController,
                    ),
                    TextFieldWidget(
                      nameLable: "Mật khẩu",
                      controller: passwordController,
                      typePassword: true,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 18,
                        margin:
                            const EdgeInsets.fromLTRB(ds_1, ds_1, ds_1, ds_1),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.primaryColor,
                          ),
                          onPressed: _loggin,
                          child: Text(
                            "Đăng Nhập",
                            style: MainStyle.textStyle5,
                          ),
                        )),
                  ],
                )),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
