import 'package:flutter/material.dart';
import 'package:mobile6_examples/week9/credentials_store.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final loginController = TextEditingController();

  final passwordController = TextEditingController();

  final passwordAgainController = TextEditingController();

  final CredentialsStore _credentialsStore = CredentialsStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Column(
        children: [
          TextField(
            controller: loginController,
            decoration: const InputDecoration(
                hintText: 'Login'
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
                hintText: 'Password'
            ),
          ),
          TextField(
            controller: passwordAgainController,
            decoration: const InputDecoration(
                hintText: 'Password again'
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final login = loginController.text;
              final password = passwordController.text;
              final passwordAgain = passwordAgainController.text;

              if (password != passwordAgain) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Пароли не совпадают!',
                    ),
                  ),
                );
                return;
              }

              final success = await _credentialsStore.signUp(login, password);
              if (success) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text(
                      'Такой пользователь уже существует!',
                    ),
                  ),
                );
              }
            },
            child: const Text('Sign Up'),
          )
        ],
      ),
    );
  }
}
