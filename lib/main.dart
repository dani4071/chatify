import 'package:chatify/firebase_options.dart';
import 'package:chatify/pages/home_page.dart';
import 'package:chatify/pages/login_page.dart';
import 'package:chatify/pages/register_page.dart';
import 'package:chatify/pages/splash_page.dart';
import 'package:chatify/providers/authentication_providers.dart';
import 'package:chatify/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// TODO: once you already have a chat with someone, then you try to chat that person again from the user page, it creates a new chat with the person instead of going to your already existing chat. the comment section said the below maybe that'll help incase you need it.
/// I was just coming to ask that same thing. The chat ids are auto generated so youd have to somehow check the exact chat members list and see if the group matches up. but that seems like quite the chore and an excessive amount of firebase reads. How would you fix this?


void main() async {
  runApp(SplashPage(
    key: UniqueKey(),
    onInitializationComplete: () {
      runApp(
        const MainApp(),
      );
    },
  ));
}

/// todo check if your data is been written on the firestore database


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (BuildContext _context) {
            return AuthenticationProvider();
          },
        )
      ],
      child: MaterialApp(
        title: 'Chatify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(35, 36, 40, 1.0),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext _context) => loginPage(),
          '/home': (BuildContext _context) => homePage(),
          '/registerPage': (BuildContext _context) => registerPage(),
        },
      ),
    );
  }
}
