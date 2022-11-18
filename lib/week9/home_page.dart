import 'package:flutter/material.dart';
import 'package:mobile6_examples/week9/credentials_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _login = '';
  final CredentialsStore _credentialsStore = CredentialsStore();

  @override
  void initState() {
    super.initState();
    _getLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              _credentialsStore.forgetRemembered();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset('name'),
          Center(
            child: Text(
              'Hello, $_login!',
              style: const TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  Future _getLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _login = _credentialsStore.getCurrentLogin();
    });
  }
}
