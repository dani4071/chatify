import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message_model.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/providers/chat_page_provider.dart';
import 'package:chatify/widgets/custom_input_field.dart';
import 'package:chatify/widgets/custom_list_view_tiles.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// chat page is for where you'd see your actual chat with a person

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            this.widget.chat.uid,
            _auth,
            _messageListViewController,
          ),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceHeight * 0.03,
              vertical: _deviceWidth * 0.02,
            ),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                topBar(
                  fontSize: 20,
                  this.widget.chat.title(),
                  primaryAction: IconButton(
                    onPressed: () {
                      _pageProvider.deleteChat();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                  secondaryAction: IconButton(
                    onPressed: () {
                      _pageProvider.goBack();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromRGBO(0, 82, 218, 1.0),
                    ),
                  ),
                ),
                _messageListView(),
                _sendMessageForm(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _messageListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.length != 0) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            controller: _messageListViewController,
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _index) {
              ChatMessage _message = _pageProvider.messages![_index];
              //// basically if the senderID is equal to our own authID that means the message is our own message, so it stays by the right
              bool _isOwnMessage = _message.senderID == _auth.user.uid;
              return Container(
                  child: CustomChatListView(
                deviceHeight: _deviceHeight,
                width: _deviceWidth * 0.77,
                message: _message,
                isOwnMessage: _isOwnMessage,
                //// dont really understand the below but video 75 towards the ending
                sender: this
                    .widget
                    .chat
                    .members
                    .where((_m) => _m.uid == _message.senderID)
                    .first,
              ));
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            "Be the very first to send a messagbe",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.0009,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  //// the textform field for sending message
  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: customTextFormField(
        obscureText: false,
        //// remeber to add a regEx to prevent the user from typing jagones
        hintText: "Type a message mfer!",
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
      ),
    );
  }

  //// the button for sending the actual message
  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        onPressed: () {
          //// validate the form so that user does not submit empty message and also dont type in jagones
          _messageFormState.currentState!.save();
          //// video 80, once this is called the above saves the text in the textformfield and once saved, the value gets passed to the pageprovider.message in the messageTextField above
          _pageProvider.sendTextMessage();
          //// this clears our textform field after we hit send
          _messageFormState.currentState!.reset();

        },
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }

//// the button for sending picture message
  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          //// thats all you need to do, the function would get the image, turn it into a link and send it as a link to the database, open the function for more. video 81
          // _pageProvider.sendImageMessage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
