import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/cloud_storage_service.dart';
import 'package:chatify/services/database_service.dart';
import 'package:chatify/services/media_service.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:chatify/widgets/custom_input_field.dart';
import 'package:chatify/widgets/rounded_button.dart';
import 'package:chatify/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
// import 'lib/services/database_service.dart';
import 'package:chatify/services/database_service.dart';

class registerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _registerPageState();
  }
}

class _registerPageState extends State<registerPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorageService;
  late NavigationService _navigation;

  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _cloudStorageService = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _db = GetIt.instance.get<DatabaseService>();



    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            _profileImageField(),
            SizedBox(height: _deviceHeight * 0.03,),
            _registerForm(),
            SizedBox(height: _deviceHeight * 0.03,),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
              (_file) {
            setState(
                  () {
                _profileImage = _file;
              },
            );
          },
        );
      },
      child: () {
        if (_profileImage != null) {
          return roundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return roundedImageNetwork(
            key: UniqueKey(),
            imagePath:
            "https://images.mubicdn.net/images/cast_member/2184/cache-2992-1547409411/image-w856.jpg?size=300x",
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customTextFormField(
              onSaved: (value) {
                setState(() {
                  name = value;
                });
              },
              hintText: 'Name',
              obscureText: false,
            ),
            customTextFormField(
              onSaved: (value) {
                setState(() {
                  email = value;
                });
              },
              hintText: 'Email',
              obscureText: false,
            ),
            customTextFormField(
              onSaved: (value) {
                setState(() {
                  password = value;
                });
              },
              hintText: 'Password',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return roundedButton(
      name: "Register",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        print("Object============");
        _registerFormKey.currentState!.save();
        String? uid = await _auth.registerUserUsingEmailAndPassword(email!, password!);
        String image = "https://upload.wikimedia.org/wikipedia/commons/d/d9/20120712_Mila_Kunis_%40_Comic-con_cropped.jpg";
        await _db.createUser(uid!, email!, name!, image);
        await _auth.logout();
        await _auth.loginUsingEmailandPassword(email!, password!);
      },
    );
  }
}
