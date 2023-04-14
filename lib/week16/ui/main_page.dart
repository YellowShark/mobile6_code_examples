import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile6_examples/week16/model/todo.dart';
import 'package:mobile6_examples/week16/repository/todo_tepository.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _repository = TodoRepository();
  var _todoList = <Todo>[];

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
            _todoList[i].name,
          ),
          subtitle: Text(
            _todoList[i].description,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final item = _todoList[i];
              _showBaseDialog(
                confirmText: 'Confirm',
                firstField: item.name,
                secondField: item.description,
                onPressed: (name, desc) async {
                  await _repository.update(
                    item.id,
                    Todo(
                      name: name,
                      description: desc,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBaseDialog(
          confirmText: 'Add',
          onPressed: (name, desc) async {
            await _repository.create(
              Todo(
                name: name,
                description: desc,
              ),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _showBaseDialog({
    required String confirmText,
    required Future<void> Function(String first, String second) onPressed,
    String firstField = '',
    String secondField = '',
  }) =>
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController(text: firstField);
          final descController = TextEditingController(text: secondField);
          return AlertDialog(
            title: const Text('New ToDo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  onPressed(nameController.text, descController.text);
                  Navigator.pop(context);
                },
                child: Text(confirmText),
              )
            ],
          );
        },
      );

  Future _init() async {
    await _repository.initDB();
    _repository.todoListStream().listen((todoList) {
      _todoList = todoList;
      setState(() {});
    });
  }
}
