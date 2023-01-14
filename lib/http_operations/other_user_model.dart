import 'package:meta/meta.dart';
import 'dart:convert';

class OtherUserModel {
  OtherUserModel({
    required this.profilePic,
    required this.userName,
    required this.email,
    required this.profileText,
    required this.registeredAt,
  });

  final String? profilePic;
  final String? userName;
  final String? email;
  final String? profileText;
  final DateTime? registeredAt;

  factory OtherUserModel.fromJson(Map<String, dynamic> json) => OtherUserModel(
        profilePic: json["profile_pic"],
        userName: json["user_name"],
        email: json["email"],
        profileText: json["profile_text"],
        registeredAt: DateTime.parse(json["registered_at"]),
      );
}
