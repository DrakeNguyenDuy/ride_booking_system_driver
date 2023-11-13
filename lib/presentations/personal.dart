// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/authentication_service.dart';
import 'package:ride_booking_system_driver/application/message_service.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';
import 'package:ride_booking_system_driver/core/utils/function_utils.dart';
import 'package:ride_booking_system_driver/presentations/edit_personal.dart';
import 'package:ride_booking_system_driver/presentations/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

// import 'package:image_picker/image_picker.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});
  static const String routeName = "/personal";

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final PersonService personalService = PersonService();
  final _messagingService = MessageService();
  String name = "";
  String gender = "";
  String address = "";
  String phoneNumber = "";
  String avatar = "";
  String email = "";
  String tokenFirebase = "";
  int idUser = -1;
  List<bool> _onOff = <bool>[true, false];
  // XFile? xFile;

  AuthenticationService authenticationService = AuthenticationService();
  // WebSocketChannel channel = IOWebSocketChannel.connect(
  //     "ws://ridebookingsystem.ddns.net:9090/triphandler");

  // late WebSocket channel;
  late IOWebSocketChannel channel;
  @override
  void initState() {
    innitData();
    super.initState();
    FunctionUtils.connect(idUser);
  }

  void changeAvatar() {
    // ImagePicker imagePicker = ImagePicker();
  }

  void showAlert() {
    // showDialog(context: context, builder: builder){
    //   retun
    // }
  }

  void _logout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  void moveEditScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPersonalScreen(
                name: name,
                address: address,
                phoneNumber: phoneNumber,
                gender: gender,
                email: email,
                userId: idUser,
              )),
    );
  }

  String getSayHi() {
    DateTime now = DateTime.now();
    int hourCurrent = now.hour;
    return hourCurrent < 12
        ? "Chào buổi sáng"
        : hourCurrent < 18
            ? "Good Afternoon"
            : "Good Evening";
  }

  void _pressItem(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Hủy"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        _logout();
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text("Are you want logout"),
            actions: [
              cancelButton,
              continueButton,
            ],
          );
        });
  }

  void changeStateConnect(bool status) async {
    await SharedPreferences.getInstance().then((ins) {
      ins.setBool(Varibales.IS_CONNECT, status);
    });
  }

  void innitData() async {
    await SharedPreferences.getInstance().then((ins) {
      setState(() {
        name = ins.getString(Varibales.NAME_USER)!;
        address = ins.getString(Varibales.ADDRESS)!;
        avatar = ins.getString(Varibales.AVATAR_USER)!;
        gender = ins.getString(Varibales.GENDER_USER)!;
        phoneNumber = ins.getString(Varibales.PHONE_NUMBER_USER)!;
        email = ins.getString(Varibales.EMAIL)!;
        idUser = ins.getInt(Varibales.DRIVER_ID)!;
        tokenFirebase = ins.getString(Varibales.TOKEN_FIREBASE)!;
        print(tokenFirebase);
        bool isConnect = ins.getBool(Varibales.IS_CONNECT)!;
        if (isConnect) {
          _onOff.clear();
          _onOff.addAll({false, true});
        }
      });
    });
  }

  ImageProvider<Object> getAvt() {
    return avatar == ""
        ? const NetworkImage("https://ui-avatars.com/api/?name=rbs")
            as ImageProvider
        : MemoryImage(base64Decode(avatar));
  }

  void onOffApp() async {
    if (_onOff.lastIndexOf(true, 1) == 1) {
      disconnect();
    } else {
      FunctionUtils.connect(idUser);
      streamBase();
    }
  }

  void disconnect() async {
    personalService.connect(idUser).then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        Fluttertoast.showToast(
            msg: "Đóng kết nối thành công", webPosition: "bottom");
      } else {
        Fluttertoast.showToast(msg: "Đã xảy ra lỗi", webPosition: "bottom");
      }
    });
    changeStateConnect(false);
  }

  Future streamBase() async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://ridebookingsystem.ddns.net:9090/socketHandler'),
    );
    channel.sink.add(
        '{"userId": $idUser, "latitude": 10.763932849773887, "longitude": 106.6817367439953, "token": "$tokenFirebase", "timestamp":$timeStamp}');
    channel.stream.listen((message) {
      print('Received: $message');
    });
    Future.delayed(const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorPalette.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    color: ColorPalette.grayLight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(getSayHi(),
                                  style: TextStyleApp.ts_1.copyWith(
                                    color: ColorPalette.primaryColor,
                                    letterSpacing: 1,
                                  )),
                              Text(name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyleApp.tsHeader.copyWith(
                                      fontSize: fs_6,
                                      inherit: true,
                                      textBaseline: TextBaseline.ideographic,
                                      overflow: TextOverflow.fade)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.height / 18,
                                backgroundColor: Colors.teal,
                                backgroundImage: getAvt(),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    print("ok");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                            50,
                                          ),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 4),
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 3,
                                          ),
                                        ]),
                                    child: const Padding(
                                      padding: EdgeInsets.all(ds_1),
                                      child: Icon(Icons.add_a_photo,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
              Expanded(
                flex: 3,
                child: ListView(
                  padding: const EdgeInsets.all(ds_1),
                  children: [
                    ListTile(
                      title: const Text("Kích hoạt ứng dụng"),
                      autofocus: true,
                      minLeadingWidth: 0,
                      selectedColor: ColorPalette.blue,
                      trailing: ToggleButtons(
                        isSelected: _onOff,
                        fillColor: ColorPalette.primaryColor,
                        selectedColor: ColorPalette.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        onPressed: (int index) {
                          onOffApp();
                          // All buttons are selectable.
                          setState(() {
                            for (int i = 0; i < _onOff.length; i++) {
                              _onOff[i] = i == index;
                            }
                          });
                        },
                        children: const [Text("Tắt"), Text("Mở")],
                      ),
                    ),
                    ListTile(
                      title: const Text("Chỉnh sửa thông tin cá nhân"),
                      autofocus: true,
                      minLeadingWidth: 0,
                      selectedColor: ColorPalette.blue,
                      onTap: () => moveEditScreen(),
                    ),
                    ListTile(
                        title: const Text("Đăng xuất"),
                        onTap: () => _pressItem(context)),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
