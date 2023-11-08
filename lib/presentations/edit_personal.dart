import 'package:flutter/material.dart';
import 'package:ride_booking_system_driver/core/constants/constants/color_constants.dart';
import 'package:ride_booking_system_driver/core/constants/constants/dimension_constanst.dart';
import 'package:ride_booking_system_driver/core/style/main_style.dart';
import 'package:ride_booking_system_driver/core/widgets/text_field_widget.dart';

class EditPersonalScreen extends StatefulWidget {
  final String name;
  final String gender;
  final String phoneNumber;
  final String address;
  final String email;
  const EditPersonalScreen(
      {super.key,
      required this.name,
      required this.gender,
      required this.phoneNumber,
      required this.address,
      required this.email});
  static const String routeName = "/personal/edit";

  @override
  State<EditPersonalScreen> createState() => _EditPersonalScreenState();
}

class _EditPersonalScreenState extends State<EditPersonalScreen> {
  late TextEditingController nameEC;
  late TextEditingController phoneNumberEC;
  late TextEditingController addressEC;
  late TextEditingController mailEC;
  List<bool> _gender = <bool>[true, false];
  @override
  void initState() {
    nameEC = TextEditingController(text: widget.name);
    phoneNumberEC = TextEditingController(text: widget.phoneNumber);
    mailEC = TextEditingController(text: widget.email);
    addressEC = TextEditingController(text: widget.address);
    super.initState();
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
                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Giới tính"),
                      ToggleButtons(
                        fillColor: ColorPalette.primaryColor,
                        selectedColor: ColorPalette.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        isSelected: _gender,
                        children: const [Text("Nam"), Text("Nữ")],
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _gender.length; i++) {
                              _gender[i] = i == index;
                            }
                          });
                        },
                      ),
                    ]),
              ),
              TextFieldWidget(
                nameLable: "Số điện thoại",
                controller: phoneNumberEC,
              ),
              TextFieldWidget(
                nameLable: "Email",
                controller: mailEC,
              ),
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
                    onPressed: () {
                      print("object");
                    },
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
