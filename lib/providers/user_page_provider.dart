import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;


  late DatabaseService _database;
  late NavigationService _navigation;


  List<ChatUserModel>? users;
  //// the below would hold onto the users when they are selected to be able to get their ID and start a group chat with them. also maybe aswell start a chat
  late List<ChatUserModel> _selectedUsers;


  //// this gets selected users, the one above
  List<ChatUserModel> get selectedUser {
    return _selectedUsers;
  }

  UsersPageProvider(this._auth){
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
  }

  @override
  void dispose() {
    super.dispose();
  }
}