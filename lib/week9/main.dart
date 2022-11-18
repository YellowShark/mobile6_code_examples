import 'package:flutter/material.dart';
import 'package:mobile6_examples/week9/home_page.dart';
import 'package:mobile6_examples/week9/login_page.dart';
import 'package:mobile6_examples/week9/sign_up_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/sign_up': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}