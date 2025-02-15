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

  Future<QuerySnapshot> getUsers(String? name) {
    Query _query = _db.collection(user_Collection);
    //// if we're provided a name then we check if theres a user with that exact name [thats what that isGreaterThan... does] but if we stop there we'd only return the query with the extact name. But if we want to return the query whereby the name matched in any position, we use the[isLessThan... with a + "z"]
    //// its an interesting concept, dont confuse yourself, check video 90. 2:27. its well explained. cause i understood it.
    if (name != null) {
      _query = _query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
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

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat = await _db.collection(chat_Collection).add(_data);
      return _chat;
    } catch (e) {
      print(e);
    }
  }
}
