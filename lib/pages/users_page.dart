import 'package:flutter/material.dart';


class usersPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _usersPageState();
  }
}

class _usersPageState extends State<usersPage> {


  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }


  Widget _buildUI() {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}