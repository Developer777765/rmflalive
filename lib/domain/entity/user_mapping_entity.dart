import 'dart:convert';

UserMappingReqEntiry userMappingReqFromJson(String str) =>
    UserMappingReqEntiry.fromJson(json.decode(str));

String userMappingReqToJson(UserMappingReqEntiry data) =>
    json.encode(data.toJson());

class UserMappingReqEntiry {
  String? brId;
  String? password;
  String? pkId;
  UserMappingReqEntiry({this.brId, this.password, this.pkId});

  factory UserMappingReqEntiry.fromJson(Map<String, dynamic> json) =>
      UserMappingReqEntiry(
          brId: json["brId"], password: json["password"], pkId: json["pkId"]);

  Map<String, dynamic> toJson() =>
      {"brId": brId, "password": password, "pkId": pkId};
}
