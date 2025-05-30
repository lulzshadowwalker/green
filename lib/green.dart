import 'package:flutter/material.dart';
import 'package:green/screen/home/home.dart';
import 'package:green/screen/login/login_screen.dart';

class Green extends StatelessWidget {
  const Green({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Home(),
      },
    );
  }
}
