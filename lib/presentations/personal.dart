import 'package:flutter/material.dart';
import 'package:ride_booking_system/application/authentication_service.dart';
import 'package:ride_booking_system/application/personal_service.dart';
import 'package:ride_booking_system/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system/core/constants/constants/font_size_constanst.dart';
import 'package:ride_booking_system/core/constants/variables.dart';
import 'package:ride_booking_system/core/style/text_style.dart';
import 'package:ride_booking_system/data/model/Personal.dart';
import 'package:ride_booking_system/presentations/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});
  static const String routeName = "/login";

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  // bool _isLogged = false;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final PersonService personalService = PersonService();
  late PersonalInfor personalInfor;

  String dataFromChild = "";
  AuthenticationService authenticationService = AuthenticationService();
  @override
  void initState() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    innitData();
  }

  void _logout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false);
  }

  String getSayHi() {
    DateTime now = DateTime.now();
    int hourCurrent = now.hour;
    return hourCurrent < 12
        ? "Good Morning"
        : hourCurrent < 18
            ? "Good Afternoon"
            : "Good Evening";
  }

  void _pressItem(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
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

  void innitData() async {
    // final SharedPreferences sp = await SharedPreferences.getInstance();
    // String? personalInfo = sp.getString(Varibales.PERSONAL_INFO);
    // String? a = sp.getString(Varibales.ACCESS_TOKEN);
    await SharedPreferences.getInstance().then((ins) {
      String? s = ins.getString(Varibales.ACCESS_TOKEN);
      print("===>");
      print(s);
    });
  }

  // void innitData() async {
  //   final SharedPreferences sp = await SharedPreferences.getInstance();
  //   String? personalInfo = sp.getString(Varibales.PERSONAL_INFO);
  //   if (personalInfo == null) {
  //     String? accessToken = sp.getString(Varibales.ACCESS_TOKEN);
  //     // _getPersonal("", sp);
  //   } else {}
  // }

  // void _getPersonal(String id, SharedPreferences sp) async {
  //   personalService.getInfo("5").then((res) {
  //     if (res.statusCode == 200) {
  //       final body = jsonDecode(res.body);
  //       personalInfor = mapperJson2Model(body);
  //       sp.setString(Varibales.PERSONAL_INFO, jsonEncode(body));
  //       print(personalInfor);
  //     } else {
  //       Fluttertoast.showToast(msg: "error");
  //     }
  //   });
  // }

  // PersonalInfor mapperJson2Model(dynamic body) {
  //   return PersonalInfor(
  //     body["personId"],
  //     body["name"],
  //     body["gender"],
  //     body["phoneNumber"],
  //     body["email"],
  //     body["address"],
  //     body["citizenId"],
  //     body["avatar"],
  //     body["userModel"]["username"],
  //     body["userModel"]["enabled"],
  //     body["userModel"]["roleId"],
  //     body["userModel"]["name"],
  //   );
  // }

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
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         fit: BoxFit.fill,
                    //         image: NetworkImage(
                    //             "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif"))),
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
                            Text("Nguyễn Dũy Long",
                                style: TextStyleApp.tsHeader.copyWith(
                                    fontSize: fs_6,
                                    inherit: true,
                                    textBaseline: TextBaseline.ideographic,
                                    overflow: TextOverflow.fade))
                          ],
                        ),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height / 20,
                          backgroundColor: Colors.teal,
                          backgroundImage:
                              const NetworkImage("https://i.pravatar.cc/300"),
                          child: const ElevatedButton(
                            onPressed: null,
                            child: Text("c",
                                style: TextStyle(
                                    backgroundColor: ColorPalette.yellow)),
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
                    const ListTile(
                      title: Text("Edit personal"),
                      autofocus: true,
                      // iconColor: ColorPalette.organge,
                      // leading: Icon(Icons.abc),
                      minLeadingWidth: 0,
                      selectedColor: ColorPalette.blue,
                    ),
                    const ListTile(
                      title: Text("Language"),
                    ),
                    ListTile(
                        title: const Text("Log out"),
                        onTap: () => _pressItem(context)),
                  ],
                ),
              )
            ],
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
