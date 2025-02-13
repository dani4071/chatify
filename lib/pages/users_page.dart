import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/providers/user_page_provider.dart';
import 'package:chatify/widgets/custom_input_field.dart';
import 'package:chatify/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_list_view_tiles.dart';

class usersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _usersPageState();
  }
}

class _usersPageState extends State<usersPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      //// this is basically like the widget that watches it incase theres change
      _pageProvider = _context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceHeight * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            topBar(
              "Users",
              primaryAction: IconButton(
                onPressed: () {},
                icon: Icon(Icons.logout),
                color: const Color.fromRGBO(0, 82, 218, 1.0),
              ),
            ),
            customTextField(
              onEditingComplete: (_value) {},
              hintText: "Search...",
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _userList(),
          ],
        ),
      );
    });
  }

  Widget _userList() {
    return Expanded(
      child: () {
        return ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext _context, int _index) {
            return CustomListViewTile(
              height: _deviceHeight * 0.10,
              title: "User $_index",
              subtitle: "Last Active:",
              imagePath:
                  "https://i.pinimg.com/736x/ae/1f/45/ae1f45ec71b4d47f37d03974adc732ad.jpg",
              isActive: true,
              isSelected: false,
              onTap: () {},
            );
          },
        );
      }(),
    );
  }
}
