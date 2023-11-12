// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_progress/loading_progress.dart';
import 'package:ride_booking_system_driver/application/personal_service.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/constants/variables.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/widgets/text_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPersonalScreen extends StatefulWidget {
  final String name;
  final String gender;
  final String phoneNumber;
  final String address;
  final String email;
  final int userId;
  const EditPersonalScreen(
      {super.key,
      required this.name,
      required this.gender,
      required this.phoneNumber,
      required this.address,
      required this.email,
      required this.userId});
  static const String routeName = "/personal/edit";

  @override
  State<EditPersonalScreen> createState() => _EditPersonalScreenState();
}

class _EditPersonalScreenState extends State<EditPersonalScreen> {
  late TextEditingController nameEC;
  late TextEditingController phoneNumberEC;
  late TextEditingController addressEC;
  late TextEditingController mailEC;
  List<String> _genders = <String>['Female', 'Male'];
  String genderSelected = "";
  PersonService personalService = PersonService();

  @override
  void initState() {
    nameEC = TextEditingController(text: widget.name);
    phoneNumberEC = TextEditingController(text: widget.phoneNumber);
    mailEC = TextEditingController(text: widget.email);
    addressEC = TextEditingController(text: widget.address);
    super.initState();
  }

  void _updateInfor() {
    LoadingProgress.start(context);
    personalService
        .editPersonal(
            nameEC.text,
            genderSelected == "" ? widget.gender : genderSelected,
            phoneNumberEC.text,
            addressEC.text,
            widget.userId)
        .then((res) async {
      if (res.statusCode == HttpStatus.ok) {
        final body = jsonDecode(res.body);
        await SharedPreferences.getInstance().then((ins) {
          ins.setString(Varibales.NAME_USER, body["data"]["name"]);
          ins.setString(Varibales.GENDER_USER, body["data"]["gender"]);
          ins.setString(
              Varibales.PHONE_NUMBER_USER, body["data"]["phoneNumber"]);
          ins.setString(Varibales.ADDRESS, body["data"]["address"]);
          ins.setString(Varibales.EMAIL, body["data"]["email"]);
        });
        Fluttertoast.showToast(
            msg: "Cập nhật thành công", webPosition: "bottom");
        LoadingProgress.stop(context);
        Navigator.pop(context);
      } else {
        LoadingProgress.stop(context);
        Fluttertoast.showToast(
            msg: "Cập nhật không thành công", webPosition: "bottom");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.white,
        appBar: AppBar(
          title: const Text('Chỉnh sửa thông tin'),
          backgroundColor: ColorPalette.primaryColor,
        ),
        body: SafeArea(
          child: Column(
            children: [
              TextFieldWidget(
                nameLable: "Họ và tên",
                controller: nameEC,
              ),
              Padding(
                padding: const EdgeInsets.all(ds_1),
                child: DropdownMenu<String>(
                  inputDecorationTheme: const InputDecorationTheme(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ds_3)),
                        borderSide: BorderSide(
                            width: ds_0, color: ColorPalette.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(ds_3)),
                        borderSide: BorderSide(
                            width: ds_0, color: ColorPalette.primaryColor),
                      )),
                  width: MediaQuery.of(context).size.width - ds_2,
                  hintText: "Giới tính",
                  initialSelection: widget.gender,
                  onSelected: (String? value) {
                    setState(() {
                      genderSelected = value!;
                    });
                  },
                  dropdownMenuEntries:
                      _genders.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              TextFieldWidget(
                nameLable: "Số điện thoại",
                controller: phoneNumberEC,
              ),
              // TextFieldWidget(
              //   nameLable: "Email",
              //   controller: mailEC,
              // ),
              TextFieldWidget(
                nameLable: "Địa chỉ",
                controller: addressEC,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 18,
                  margin: const EdgeInsets.fromLTRB(ds_1, ds_1, ds_1, ds_1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    onPressed: _updateInfor,
                    child: Text(
                      "Lưu",
                      style: MainStyle.textStyle5,
                    ),
                  ))
            ],
          ),
        ));
  }
}
