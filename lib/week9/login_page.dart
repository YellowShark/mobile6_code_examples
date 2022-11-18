import 'package:flutter/material.dart';
import 'package:mobile6_examples/week9/credentials_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final CredentialsStore _credentialsStore = CredentialsStore();
  var remember = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: loginController,
            decoration: const InputDecoration(hintText: 'Login'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
          ),
          CheckboxListTile(
            value: remember,
            onChanged: (b) {
              setState(() {
                remember = b ?? false;
              });
            },
            title: const Text('Remember me'),
          ),
          ElevatedButton(
            onPressed: () {
              final login = loginController.text;
              final password = passwordController.text;

              if (login.isEmpty || password.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Заполните все поля!',
                    ),
                  ),
                );
                return;
              }

              final result = _credentialsStore.login(login, password);

              switch (result) {
                case LoginResult.wrongLogin:
                case LoginResult.wrongPassword:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        result.message,
                      ),
                    ),
                  );
                  return;
                case LoginResult.success:
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     backgroundColor: Colors.greenAccent,
                  //     content: Text(
                  //       result.message,
                  //     ),
                  //   ),
                  // );
                  if (remember) {
                    _credentialsStore.rememberMe();
                  }
                  Navigator.pushReplacementNamed(context, '/home');
              }
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/sign_up');
            },
            child: const Text('Create Account'),
          )
        ],
      ),
    );
  }

  void _init() async {
    await Future.delayed(const Duration(seconds: 2));
    final remember = _credentialsStore.wasRemembered();
    if (remember) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
