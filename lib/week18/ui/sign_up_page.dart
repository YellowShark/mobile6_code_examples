import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile6_examples/week18/data/firebase_helper.dart';

class SignUpPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Email'),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          TextField(
            controller: _passwordAgainController,
            decoration: const InputDecoration(hintText: 'Password again'),
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              final passwordAgain = _passwordAgainController.text;
              if (password == passwordAgain) {
                final success = await FirebaseHelper.signUp(email, password);
                if (success) {
                  context.router.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Something went wrong'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Passwords are not the same'),
                  ),
                );
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}