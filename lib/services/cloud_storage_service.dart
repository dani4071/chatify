import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String User_Collection = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService() {

  }
}