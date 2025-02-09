import 'dart:async';

import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message_model.dart';
import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class chatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;

  List<Chat>? chats;

  late StreamSubscription _chatStream;

  chatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    /// okay so basically when the chatPageProvider is destroyed, i want you to destroy the chat chatstream and stop listening to it.
    _chatStream.cancel();
    super.dispose();
  }


  /// this is very easy actually, just watch video 64 and you'd get it.
  void getChats() async {
    try {
      //// getting the chats of the user by listening to it incase anything changes
      _chatStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        //// taking the result and storing it into a List of Chat, thats why we have to perform the operation of making it into a list of chats
        //// why did we use Future.wait?? cause if you hover round _snapshot.docs.map you're returning a future list, now we used the future.wait to help us return a future and parse it in as a List
        chats = await Future.wait(
          _snapshot.docs.map(
            (_d) async {
              //// got the data from the _d and casted it as a map so that we could parse it into the _chatData so that we can call _chatData['is_activity']...
              Map<String, dynamic> _chatData =
                  _d.data() as Map<String, dynamic>;

              /// Get  Users in chat
              List<ChatUserModel> _members = [];
              //// loop around the members and get the members id, then parse it into _db.getUser(_uid) then the next line casts it as a map, then the next line maps it into the factory of the userModel.fromJson. video 64 - 9:55
              //// members in the database is all their ids, check databse if you forgot
              for (var _uid in _chatData['members']) {
                //// create a document snap variable to hold onto it
                DocumentSnapshot _userSnapShot = await _db.getUser(_uid);

                Map<String, dynamic> _userData =
                    _userSnapShot.data() as Map<String, dynamic>;

                _userData["uid"] = _userSnapShot.id;
                _members.add(ChatUserModel.fromJson(_userData));
              }

              /// Get last message for chat
              List<ChatMessage> _messages = [];
              QuerySnapshot _chatMessage =
                  await _db.getLastMessageForChat(_d.id);

              if (_chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> _messageData =
                    _chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage _message = ChatMessage.fromJSON(_messageData);
                _messages.add(_message);
              }

              /// return chat instance
              return Chat(
                uid: _d.id,
                currentUserUid: _auth.user.uid,
                members: _members,
                messages: _messages,
                activity: _chatData['is_activity'],
                group: _chatData['is_group'],
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("Error getting chats");
      print(e);
    }
  }
}
