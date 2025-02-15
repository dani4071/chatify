import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class UsersPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _database;
  late NavigationService _navigation;

  List<ChatUserModel>? users;

  //// the below would hold onto the users when they are selected to be able to get their ID and start a group chat with them. also maybe aswell start a chat
  //// video 92 talks about selecting user to chat
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

  //// this is resposible to select users to start a chat with
  void updateSelectedUser(ChatUserModel _user) {
    if (_selectedUsers.contains(_user)) {
      _selectedUsers.remove(_user);
    } else {
      _selectedUsers.add(_user);
    }
    notifyListeners();
  }

  void createChat() async {
    try {
      /// this creates the chat
      //// this gets them users we selected and mapped it into a new list, line 72 adds our own ID(the person presently logged in) to the members list. cause think about it, we need to start a chat with you and someone
      List<String> _membersIds =
          _selectedUsers.map((_user) => _user.uid).toList();
      _membersIds.add(_auth.user.uid);
      //// of course if the selected users are more than 1 then that makes it a group
      bool isGroup = _selectedUsers.length > 1;
      DocumentReference? _doc = await _database.createChat(
        {
          "is_group": isGroup,
          "is_activity": false,
          "members": _membersIds,
        },
      );

      /// navigate to the chat page after its created
      List<ChatUserModel> _members = [];
      for (var _uid in _membersIds) {
        DocumentSnapshot _usersnapshot = await _database.getUser(_uid);
        Map<String, dynamic> _userData =
            _usersnapshot.data() as Map<String, dynamic>;
        //// line 93 adds their ids cause the firebase doesnt bring back their id, base on how we structured our database
        _userData["uid"] = _usersnapshot.id;
        _members.add(
          ChatUserModel.fromJson(_userData),
        );
      }

      ChatPage _chatPage = ChatPage(
        chat: Chat(
          //// line 102, the id of the chat
          uid: _doc!.id,
          currentUserUid: _auth.user.uid,
          members: _members,
          messages: [],
          activity: false,
          group: isGroup,
        ),
      );
      //// line 111 & 112 came from a later video, video 96, 3:56. This basically just allows us to clear the selected list after we create a chat and move to the chat page
      _selectedUsers = [];
      notifyListeners();
      _navigation.navigatToPage(_chatPage);
    } catch (e) {
      print(e);
    }
  }
}
