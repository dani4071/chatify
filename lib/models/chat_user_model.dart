import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUserModel {
  final String uid;
  final String name;
  final String email;
  final String imageURL;
  late DateTime lastActive;

  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.imageURL,
    required this.lastActive,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> _json) {
    return ChatUserModel(
      uid: _json["uid"],
      name: _json["name"],
      email: _json["email"],
      imageURL: _json["image"],
        // lastActive: _json["last_active"],
      lastActive: _json["last_active"] != null
          ? (_json["last_active"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "last_active": lastActive,
      "image": imageURL
    };
  }

  String lastDayActive() {
    return "${lastActive.month}/${lastActive.day}/${lastActive.year}";
  }

// bool wasRecentlyActive() {
//   return DateTime.now().difference(lastActive).inHours / 2;
// }
}
