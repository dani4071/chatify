import 'package:chatify/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String user_Collection = "users";
const String chat_Collection = "Chats";
const String message_Collection = "messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      _db.collection(user_Collection).doc(_uid).set({
        "email": _email,
        "image": _imageURL,
        "last_active": DateTime.now().toUtc(),
        "name": _name,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(user_Collection).doc(_uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(chat_Collection)
        .where('members', arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) async {
    return _db
        .collection(chat_Collection)
        .doc(_chatID)
        .collection(message_Collection)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessageForChat(String _chatID) {
    return _db
        .collection(chat_Collection)
        .doc(_chatID)
        .collection(message_Collection)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  //// send a message in our chat
  Future<void> addMessageToChat(String _chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(chat_Collection)
          .doc(_chatID)
          .collection(message_Collection)
          .add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(chat_Collection).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }


  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(user_Collection).doc(_uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }


  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(chat_Collection).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }
}
