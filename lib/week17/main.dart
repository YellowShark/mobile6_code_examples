import 'package:flutter/material.dart';
import 'package:mobile6_examples/week17/placemarks_page.dart';
import 'package:mobile6_examples/week17/yandex_map_page.dart';

const googleApiKey = "AIzaSyBLR3iEOULZSNtuNNhhGLIpTASvwxvVLg4";

void main() {
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
        '/home' : (_) => const PlacemarksPage(),
        '/detail' : (_) => const YandexMapPage(),
      },
    );
  }
}
