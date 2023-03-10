import 'package:flutter/material.dart';
import 'package:mobile6_examples/week22/ui/recipes/recipes_screen.dart';
import 'package:mobile6_examples/week22/di/config.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (_) => RecipesScreen(),
      },
    );
  }
}