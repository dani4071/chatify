import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;

  late ChatUserModel user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _navigationService = GetIt.instance<NavigationService>();
    _databaseService = GetIt.instance<DatabaseService>();

    _auth.authStateChanges().listen((_user) {
      print(_user?.uid);
      if (_user != null) {
        _databaseService.updateUserLastSeenTime(_user.uid);
        //// this is going to store the user data in the factory
        _databaseService.getUser(_user.uid).then((_snapshot) {
          Map<String, dynamic> _userData =
              _snapshot.data()! as Map<String, dynamic>;
          user = ChatUserModel.fromJson(
            {
              "uid": _user.uid,
              "name": _userData["name"],
              "email": _userData["email"],
              "last_active": _userData["last_active"],
              "image": _userData["image"],
            },
          );
          _navigationService.removeAndNavigatToRoute('/home');
        });
      } else {
        _navigationService.removeAndNavigatToRoute('/login');
      }
    });
  }

  Future<void> loginUsingEmailandPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print(_auth.currentUser);
      _navigationService.navigatToRoute("/home");
    } catch (e) {
      print(e);
    }
  }

  Future<String?> registerUserUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential _credentials = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
      return _credentials.user?.uid;
    } catch (e) {
      print("bshbdc dsnjds njdsn");
    }
  }


  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}


