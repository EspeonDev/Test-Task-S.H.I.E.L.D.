import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shield_command_center/constants/app_style.dart';
import 'package:shield_command_center/screens/authentication_screen.dart';
import 'package:shield_command_center/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppStyles.primaryColor,
        fontFamily: 'LexendDeca',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthenticationScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
