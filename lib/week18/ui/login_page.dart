import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile6_examples/week18/common/router/router.dart';
import 'package:mobile6_examples/week18/data/firebase_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //checkUser();
    fillFields();
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
                final sp = await SharedPreferences.getInstance();
                sp.setString('login', email);
                sp.setString('password', password);
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

  void checkUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      context.router.popAndPush(ProfileRoute());
    }
  }

  Future fillFields() async {
    final sp = await SharedPreferences.getInstance();
    final login = sp.getString('login');
    final password = sp.getString('password');

    _emailController.text = login ?? "";
    _passwordController.text = password ?? "";
  }
}