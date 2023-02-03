import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile6_examples/week18/common/router/router.dart';
import 'package:mobile6_examples/week18/data/firebase_helper.dart';

class LoginPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'email'),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'password'),
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              final success = await FirebaseHelper.login(email, password);
              if (success) {
                context.router.push(ProfileRoute());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Wrong email or password'),
                  ),
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              context.router.push(const SignUpRoute());
            },
            child: const Text('Firstly here? Sign up!'),
          ),
        ],
      ),
    );
  }
}