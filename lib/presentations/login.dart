// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:ride_booking_system/application/authentication_service.dart';
import 'package:ride_booking_system/core/constants/constants/assets_images.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system/core/constants/variables.dart';
import 'package:ride_booking_system/core/style/main_style.dart';
import 'package:ride_booking_system/core/widgets/text_field_widget.dart';
import 'package:ride_booking_system/data/model/Personal.dart';
import 'package:ride_booking_system/presentations/main_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool _isLogged = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  AuthenticationService authenticationService = AuthenticationService();
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
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
          LoadingProgress.stop(context);
          Fluttertoast.showToast(
              backgroundColor: Colors.amberAccent,
              msg: body['data']['message'],
              webPosition: "top");
        }
        var userInfo = body['data']['userInfo'];
        PersonalInfor personalInfor = mapperJson2Model(userInfo);
        // final SharedPreferences sp =
        await SharedPreferences.getInstance().then((ins) {
          ins.setString(Varibales.ACCESS_TOKEN, body['data']['accessToken']);
          ins.setString(
              Varibales.PERSONAL_INFO, jsonEncode(personalInfor.toString()));
        });
        LoadingProgress.stop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainApp()),
            (route) => false);
      } else {
        LoadingProgress.stop(context);
        Fluttertoast.showToast(
            msg: "Username or Password incorrect!", webPosition: "top");
        // LoadingProgress.stop(context);
      }
    });
    // Navigator.pushAndRemoveUntil(context,
    //     MaterialPageRoute(builder: (_) => const MainApp()), (route) => false);
  }

  PersonalInfor mapperJson2Model(dynamic userInfoJson) {
    return PersonalInfor(
      userInfoJson["personModel"]["personId"],
      userInfoJson["personModel"]["name"],
      userInfoJson["personModel"]["gender"],
      userInfoJson["personModel"]["phoneNumber"],
      userInfoJson["personModel"]["email"],
      userInfoJson["personModel"]["address"],
      userInfoJson["personModel"]["citizenId"],
      userInfoJson["personModel"]["avatar"],
      userInfoJson["username"],
      userInfoJson["enabled"],
      userInfoJson["roleModel"]["roleId"],
      userInfoJson["roleModel"]["name"],
    );
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
                      "Let's First Go Login",
                      style: MainStyle.textStyle1.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: fs_3 * 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextFieldWidget(
                      nameLable: "User Name",
                      controller: userNameController,
                    ),
                    TextFieldWidget(
                      nameLable: "Password",
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
                            // padding: const EdgeInsets.all(15.0),
                          ),
                          onPressed: _loggin,
                          child: Text(
                            "Login",
                            style: MainStyle.textStyle5,
                          ),
                        )),
                    Text(
                      "Forgot password",
                      style: MainStyle.textStyle5.copyWith(
                        color: ColorPalette.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
                // Expanded(child: null)
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

// const Text("Hãy đăng nhập đi",
//           style: TextStyle(
//               color: Color.fromARGB(255, 57, 241, 100),
//               fontSize: 100.0,
//               fontWeight: FontWeight.w700)),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _logged,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//  Image.network(
//                 "https://assets.materialup.com/uploads/c18c728e-b55c-4195-9b50-16bb2d767908/mockup.png"),
//           )
