import 'package:ride_booking_system_driver/data/model/personal.dart';

class ConverterData {
  static PersonalInfor mapperJson2Model(dynamic userInfoJson) {
    return PersonalInfor(
      userInfoJson["personModel"]["userId"],
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
}
