import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';

class PostListModel {
  PostListModel({
    required this.postId,
    required this.userId,
    required this.userName,
    required this.profilePic,
    required this.postTitle,
    required this.postContent,
    required this.postSummary,
    required this.timePosted,
  });

  final int? postId;
  final int userId;
  final String userName;
  final dynamic profilePic;
  final String postTitle;
  final String postContent;
  final String postSummary;
  final DateTime? timePosted;

  factory PostListModel.fromJson(Map<String, dynamic> json) => PostListModel(
        postId: json["post_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        profilePic: json["profile_pic"],
        postTitle: json["post_title"],
        postContent: json["post_content"],
        postSummary: json["post_summary"],
        timePosted: DateTime.parse(json["time_posted"]),
      );
}
