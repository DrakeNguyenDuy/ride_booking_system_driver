// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ride_booking_system_driver/application/authentication_service.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/text_style.dart';
import 'package:ride_booking_system_driver/presentations/edit_personal.dart';
import 'package:ride_booking_system_driver/presentations/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
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
    // getData();

    connect();
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
      connect();
      // connectSocket();
      streamBase();
    }
  }

  void connect() async {
    personalService.connect(idUser).then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        Fluttertoast.showToast(
            msg: "Kết nối thành công", webPosition: "bottom");
      } else {
        Fluttertoast.showToast(msg: "Đã xảy ra lỗi", webPosition: "bottom");
      }
    });
    changeStateConnect(true);
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

  // void connectSocket() async {
  //   print("conecting...");
  //   this.channel = await WebSocket.connect(
  //       'ws://ridebookingsystem.ddns.net:9090/socketHandler');
  //   print("socket connection initializied");
  //   channel.add('Hello, WebSocket server!');
  //   // Listen for incoming messages
  //   channel.listen((message) {
  //     print('Received: $message');
  //   }, onError: (error) {
  //     print('Error: $error');
  //   }, onDone: () {
  //     print('WebSocket closed');
  //   });
  // }

  // void connectSocket() {
  //   final channel = IOWebSocketChannel.connect(
  //     Uri.parse('ws://ridebookingsystem.ddns.net:9090/socketHandler'),
  //   );

  //   channel.sink.add({
  //     "userId": 9,
  //     "latitude": 10.763932849773887,
  //     "longitude": 106.6817367439953,
  //     "token":
  //         "ds607-SkSPObVhAmBldEqS:APA91bFucNLQuNDuTP3jT9aDNT2BtbCdWE75CfN4sMuZj--x9lVP1ww9dk3aegSJsDZmeQT8htdvfYrBoL-lbWpRPIOlIcykadcZGDfQaIO2n2EC2B4rMOjXsC0lay91s7GwIfHHa1RM",
  //     "timestamp": 3123123123
  //   });
  //   channel.stream.listen((message) {
  //     print('Received: $message');
  //   });
  // }

  Future streamBase() async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    channel = IOWebSocketChannel.connect(
      Uri.parse('ws://ridebookingsystem.ddns.net:9090/socketHandler'),
    );
    channel.sink.add(
        '{"userId": $idUser, "latitude": 10.763932849773887, "longitude": 106.6817367439953, "token": "$tokenFirebase", "timestamp":$timeStamp}');
    print(channel);
    channel.stream.listen((message) {
      print('Received: $message');
    });
    Future.delayed(const Duration(seconds: 5));
  }

  // a() async {
  //   try {
  //     return await WebSocket.connect(
  //         'ws://ridebookingsystem.ddns.net:9090/socketHandler');
  //   } catch (e) {
  //     print("Error! can not connect WS connectWs " + e.toString());
  //     await Future.delayed(Duration(milliseconds: 10000));
  //     return await a();
  //   }
  // }

  void close() {
    // channel.close(1, "d");
    // channel.
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(getSayHi(),
                                style: TextStyleApp.ts_1.copyWith(
                                  color: ColorPalette.primaryColor,
                                  letterSpacing: 1,
                                )),
                            Text(name,
                                style: TextStyleApp.tsHeader.copyWith(
                                    fontSize: fs_6,
                                    inherit: true,
                                    textBaseline: TextBaseline.ideographic,
                                    overflow: TextOverflow.fade)),
                            // Text(phoneNumber,
                            //     style: TextStyleApp.ts_1.copyWith(
                            //       color: ColorPalette.primaryColor,
                            //       letterSpacing: 1,
                            //     )),
                            // Text(gender == "FEMALE" ? "Nữ" : "Nam",
                            //     style: TextStyleApp.tsHeader.copyWith(
                            //         fontSize: fs_6,
                            //         inherit: true,
                            //         textBaseline: TextBaseline.ideographic,
                            //         overflow: TextOverflow.fade)),
                          ],
                        ),
                        // CircleAvatar(
                        //   radius: MediaQuery.of(context).size.height / 20,
                        //   backgroundColor: Colors.teal,
                        //   backgroundImage: getAvt(),
                        // )
                        Stack(
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
                    ListTile(title: const Text("Đóng"), onTap: () => close()),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
