import 'package:meta/meta.dart';
import 'dart:convert';

class AuthorisedUserModel {
  AuthorisedUserModel({
    required this.userId,
    required this.profilePic,
    required this.userName,
    required this.email,
    required this.password,
    required this.profileText,
    required this.registeredAt,
  });

  final int userId;
  final String? profilePic;
  final String userName;
  final String email;
  final String password;
  final String? profileText;
  final DateTime registeredAt;

  factory AuthorisedUserModel.fromJson(Map<String, dynamic> json) =>
      AuthorisedUserModel(
        userId: json["user_id"],
        profilePic: json["profile_pic"],
        userName: json["user_name"],
        email: json["email"],
        password: json["password"],
        profileText: json["profile_text"],
        registeredAt: DateTime.parse(json["registered_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "profile_pic": profilePic,
        "user_name": userName,
        "email": email,
        "password": password,
        "profile_text": profileText,
        "registered_at": registeredAt.toIso8601String(),
      };
}
