import 'package:chatify/models/chat_user_model.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/providers/user_page_provider.dart';
import 'package:chatify/widgets/custom_input_field.dart';
import 'package:chatify/widgets/rounded_button.dart';
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
                onPressed: () {
                  _auth.logout();
                },
                icon: Icon(Icons.logout),
                color: const Color.fromRGBO(0, 82, 218, 1.0),
              ),
            ),
            customTextField(
              onEditingComplete: (_value) {
                _pageProvider.getUser(name: _value);
                FocusScope.of(context).unfocus();
              },
              hintText: "Search...",
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _userList(),
            _createChatButton(),
          ],
        ),
      );
    });
  }

  Widget _userList() {
    //// video 91 but all these are fairly easy, just calm down watch the video again.
    List<ChatUserModel>? _users = _pageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int _index) {
                return CustomListViewTile(
                  height: _deviceHeight * 0.10,
                  title: _users[_index].name,
                  subtitle: "Last Active:${_users[_index].lastDayActive()}",
                  imagePath: _users[_index].imageURL,
                  isActive: _users[_index].wasRecentlyActive(),
                  // isSelected: false,
                  //// the below returns a boolean, i purposely left the above. the below returns true or false and based on that the ui gets a check mark or not, the function explains itself actually. video 92
                  isSelected:
                      _pageProvider.selectedUser.contains(_users[_index]),
                  onTap: () {
                    //// this parses the uid of the user to the below function... video 92 if you don't understand but its easy
                    _pageProvider.updateSelectedUser(_users[_index]);
                  },
                );
              },
            );
          } else {
            return const Text(
              "No users was found",
              style: TextStyle(color: Colors.white),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }

  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUser.isNotEmpty,
      child: roundedButton(
        name: _pageProvider.selectedUser.length == 1 ? "Chat with ${_pageProvider.selectedUser.first.name}" : "Create Group Chat",
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
}
