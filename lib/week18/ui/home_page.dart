import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile6_examples/week18/common/router/router.dart';
import 'package:mobile6_examples/week18/data/firebase_helper.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var username = '';
  var generalMessage = '';
  var tasks = <String>[];

  @override
  void initState() {
    super.initState();
    _initUsername();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseHelper.logout();
              context.router.pop(LoginRoute());
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(child: Text('Hello, $username!')),
          const SizedBox(height: 24),
          Center(child: Text(generalMessage)),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(tasks[i]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _initUsername() async {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';
    setState(() {
      username = email;
    });
  }

  void _initData() {
    FirebaseHelper.getTasks().listen((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map != null) {
        setState(() {
          tasks = map.values.map((e) => e as String).toList();
        });
      }
    });

    FirebaseHelper.getMessage().listen((event) {
      final message = event.snapshot.value as String?;
      if (message == null) return;
      setState(() {
        generalMessage = message;
      });
    });
  }

  Future _showDialog() => showGeneralDialog(
    context: context,
    barrierDismissible: false,
    pageBuilder: (_, __, ___) {
      final nameController = TextEditingController();
      return AlertDialog(
        title: const Text('New task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final note = nameController.text;
              FirebaseHelper.write(note);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      );
    },
  );
}