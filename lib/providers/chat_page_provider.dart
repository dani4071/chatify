import 'dart:async';

import 'package:chatify/models/chat_message_model.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  AuthenticationProvider _auth;
  ScrollController _messageListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messageStream;
  //// the below Stream subscription is responsible for keyboard showing typing or not. just like whatsapp
  late StreamSubscription _keyboardVisibilityStream;
  //// the below is from our package keyboard_visibility
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  //// video 78. 7:38. basically setting the message we get from the textbox to message so that we can hold it. for eg, like when we use controllerss to hold on to the texts a textform field.
  void set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    //// the below i think is just like assigning a controller to a textediting controller
    _keyboardVisibilityController = KeyboardVisibilityController();
    //// this gets invoked anytime our chat provider is called
    listenToMessages();
    listenToKeyboardChanges();

  }

  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }


  //// keep calm, this is easy video 72
  void listenToMessages() {
    try {
      _messageStream = _db.streamMessageForChat(_chatId).listen((_snapshot) {
        List<ChatMessage> _messages = _snapshot.docs.map(
              (_m) {
            Map<String, dynamic> _messageData =
            _m.data() as Map<String, dynamic>;
            return ChatMessage.fromJSON(_messageData);
          },
        ).toList();
        messages = _messages;
        notifyListeners();

        /// Add Scroll To Bottom call
        //// this is interesting, video 83
        //// also remeber we added the scroll controller in the listview.builder in chat_page, line 115
        //// what the below does is it tells flutter to run the function inside after the current frame has been rendered completely
        //// it will auto be scrolling as well as were adding more chats
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          //// this has client is responsible to check if we actually need to scroll down,
          if(_messageListViewController.hasClients){
            _messageListViewController.jumpTo(_messageListViewController.position.maxScrollExtent);
          }
        });


      });
    } catch (e) {
      print("Error getting messages.");
      print(e);
    }
  }


  //// video 84, but its very understandable, what it does is check if the keyboard is up and if it is, it updates the value in the database to true and then that bubble stuff that youre typing shows
  void listenToKeyboardChanges() {
    _keyboardVisibilityStream = _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity": _event});
    });
  }

  //// video 73
  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
       //// anytime this is called it takes the message and sends to the function below which saves it in the database and above we have a listerner event so when the message sends, the listener updates it into the chat. watch video 80 to understand incase
      _db.addMessageToChat(_chatId, _messageToSend);
    }
  }

  //// video 73
  /// video 73: didnt test this cause im not using a firebase storage. will only work when i enable firebase storage option
  //// responsible for sending image as message
  // void sendImageMessage() async {
  //   try {
  //     PlatformFile? _file = await _media.pickImageFromLibrary();
  //     if(_file != null) {
  //       String? _downloadURL = await _storage.saveUserImageToStorage(_chatId, _auth.user.uid, _file,);
  //       ChatMessage _messageToSend = ChatMessage(
  //         content: _downloadURL!,
  //         type: MessageType.IMAGE,
  //         senderID: _chatId,
  //         sentTime: DateTime.now(),
  //       );
  //       _db.addMessageToChat(_chatId, _messageToSend);
  //     }
  //   } catch(e) {
  //     print("Error sending image message");
  //     print(e);
  //   }
  // }

  //// video 73

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
