import 'package:flutter/material.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenState _state = ScreenState.idle;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ScreenState.loading:
        return const CircularProgressIndicator();
      case ScreenState.idle:
        return Scaffold(
          appBar: AppBar(
            title: const Text("Title"),
          ),
          body: Column(
            children: const [
              Text("Some data"),
            ],
          ),
        );
    }
  }

  void _fetchData() {
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        setState(
          () {
            _state = ScreenState.idle;
          },
        );
      },
    );
  }
}

enum ScreenState {
  loading,
  idle,
  ;
}
