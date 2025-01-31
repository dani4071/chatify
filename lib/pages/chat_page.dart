import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _buildUI();
  }

  Widget _buildUI() {
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
        ],
      ),
    );
  }
}
