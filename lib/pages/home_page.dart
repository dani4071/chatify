import 'package:chatify/pages/chats_page.dart';
import 'package:chatify/pages/users_page.dart';
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

class _homePageState extends State<homePage> {
  int _currentPage = 0;
  final List<Widget> _pages = [
    chatsPage(),
    usersPage(),
  ];





  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (_index) {
          setState(() {
            _currentPage = _index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "Chats",
            icon: Icon(Icons.chat_bubble_sharp)
          ),

          BottomNavigationBarItem(
              label: "Users",
              icon: Icon(Icons.supervised_user_circle)
          ),
        ],
      ),
    );
  }
}