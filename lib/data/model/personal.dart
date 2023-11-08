class PersonalInfor {
  final int id;
  final String name;
  final String gender;
  final String phoneNumber;
  final String mail;
  final String address;
  final String citizenId;
  final String avatar;
  final String userName;
  final bool enable;
  final int roleId;
  final String roleName;

  PersonalInfor(
      this.id,
      this.name,
      this.gender,
      this.phoneNumber,
      this.mail,
      this.address,
      this.citizenId,
      this.avatar,
      this.userName,
      this.enable,
      this.roleId,
      this.roleName);

  Map<String, dynamic> toJson(PersonalInfor personalInfor) {
    return {
      "id": personalInfor.id,
      "name": personalInfor.name,
      "gender": personalInfor.gender,
      "phoneNumber": personalInfor.phoneNumber,
      "mail": personalInfor.mail,
      "address": personalInfor.address,
      "citizenId": personalInfor.citizenId,
      "avatar": personalInfor.avatar,
      "userName": personalInfor.userName,
      "enable": personalInfor.enable,
      "roldId": personalInfor.roleId,
      "roleName": personalInfor.roleName
    };
  }

  factory PersonalInfor.fromJson(Map<String, dynamic> json) {
    return PersonalInfor(
        json["id"],
        json["name"],
        json["gender"],
        json["phoneNumber"],
        json["mail"],
        json["address"],
        json["citizenId"],
        json["avatar"],
        json["userName"],
        json["enable"],
        json["roleId"],
        json["roleName"]);
  }
}
