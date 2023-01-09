import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';

class PostListModel {
  PostListModel({
    required this.postId,
    required this.userId,
    required this.postTittle,
    required this.postContent,
    required this.timePosted,
  });

  final int? postId;
  final int? userId;
  final String? postTittle;
  final String? postContent;
  final DateTime? timePosted;

  factory PostListModel.fromJson(Map<String, dynamic> json) => PostListModel(
        postId: json["post_id"],
        userId: json["user_id"],
        postTittle: json["post_tittle"],
        postContent: json["post_content"],
        timePosted: DateTime.parse(json["time_posted"]),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "post_tittle": postTittle,
        "post_content": postContent,
        "time_posted": timePosted?.toIso8601String(),
      };
}
