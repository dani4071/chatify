import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message_model.dart';
import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/providers/chats_page_provider.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';


/// chats page is for where you'd see your chats with different person

class chatsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _chatPageState();
  }
}

class _chatPageState extends State<chatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late chatsPageProvider _pageProvider;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(providers: [
      ChangeNotifierProvider<chatsPageProvider>(
        create: (_) => chatsPageProvider(_auth),
      ),
    ], child: _buildUI());
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<chatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.032,
            vertical: _deviceWidth * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar(
                "Chats",
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              _chatsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatsList() {
    List<Chat>? _chats = _pageProvider.chats;
    print(_chats);

    /// chat not working figure it out
    return Expanded(
      // an annonymous function, it kinda means that this funtion needs to run to return
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(_chats[_index]);
              },
            );
          } else {
            return Center(
              child: Text(
                "No Chats Found!",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    /// getting the chats and setting it up
    /// video 66
    /// get chat
    List<ChatUserModel> _recipients = _chat.recepients();
    /// check if active
    bool _isActive = _recipients.any((_d) => _d.wasRecentlyActive());
    /// create subtitle in the chat listTile
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }

    /// all these was gotten from the chat provider
    return customListViewWithActivity(
      height: _deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigatToPage(ChatPage(chat: _chat));
      },
    );
  }
}
