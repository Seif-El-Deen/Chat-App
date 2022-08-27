import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_screen.dart';
import 'package:chat_app/pages/login_screen.dart';
import 'package:chat_app/pages/register_screen.dart';
import 'package:chat_app/pages/users_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chatting App",
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.routeName,
      routes: {
        UsersScreen.routeName: (context) => UsersScreen(),
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        // ChatPage.routeName: (context) => ChatPage(),
      },
      // home: LoginPage(),
    );
  }
}
