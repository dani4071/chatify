import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/custom_input_field.dart';
import 'package:chatify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginPageState();
  }
}

class _loginPageState extends State<loginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  final _loginFormKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceHeight * 0.03,
          vertical: _deviceWidth * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.10,
      child: const Text(
        'Chatify',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight * 0.18,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customTextFormField(
              onSaved: (_value) {
                setState(() {
                  email = _value;
                });
              },
              obscureText: false,
              hintText: 'Email',
            ),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            customTextFormField(
              onSaved: (_value) {
                setState(() {
                  password = _value;
                });
              },
              obscureText: true,
              hintText: 'Password',
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return roundedButton(
      name: 'Login',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () {
        _loginFormKey.currentState!.save();
        _auth.loginUsingEmailandPassword(email!, password!);
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () => _navigation.navigatToRoute("/registerPage"),
      child: const Text(
        "Don't have an account?",
        style: TextStyle(color: Colors.blueAccent),
      ),
    );
  }
}
