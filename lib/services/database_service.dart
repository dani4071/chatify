import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


const String user_Collection = "Users";
const String chat_Collection = "Chats";
const String message_Collection = "Messages";


class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  DatabaseService() {

  }

}