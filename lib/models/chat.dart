import 'package:chatify/models/chat_user_model.dart';
import 'package:flutter/material.dart';

import 'chat_message_model.dart';

//// this is for the persons chat i think
class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUserModel> members;
  List<ChatMessage> messages;

  late final List<ChatUserModel> _recipients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.activity,
    required this.group,
  }) {
    _recipients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

  //// for conveniece so that you can return the recepients
  List<ChatUserModel> recepients() {
    return _recipients;
  }

  //// returns title if single chat or group, the code explains it
  String title() {
    return !group
        ? _recipients.first.name
        : _recipients.map((_user) => _user.name).join(", ");
  }

  //// returns image if single chat or the group image, the code explains it
  String imageURL() {
    return !group
        ? _recipients.first.imageURL
        : "https://www.shutterstock.com/shutterstock/photos/171638717/display_1500/stock-vector-the-pictogram-of-a-head-with-question-mark-john-doe-illustration-the-asking-head-171638717.jpg";
  }
}
