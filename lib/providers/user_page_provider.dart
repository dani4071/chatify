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

  UsersPageProvider(this._auth) {
    _selectedUsers = [];
    _database = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    getUser();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUser({String? name}) async {
    _selectedUsers = [];
    try {
      _database.getUsers(name).then(
        (_snapshot) {
          users = _snapshot.docs.map(
            (_doc) {
              Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
              //// adding the uid field cause thats not present
              _data["uid"] = _doc.id;
              return ChatUserModel.fromJson(_data);
            },
          ).toList();
          notifyListeners();
        },
      );
    } catch (e) {}
  }
}
