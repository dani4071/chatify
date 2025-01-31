import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String user_Collection = "users";
const String chat_Collection = "Chats";
const String message_Collection = "Messages";

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

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(user_Collection).doc(_uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }
}
