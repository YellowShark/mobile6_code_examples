import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile6_examples/week16/di/config.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:mobile6_examples/week16/ui/main_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainStore _viewModel = getIt<MainStore>();

  @override
  void initState() {
    super.initState();
    _viewModel.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Observer(
        builder: (_) {
          final notes = _viewModel.notes;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(
                notes[i].name,
              ),
              subtitle: Text(
                notes[i].description,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showBaseDialog(
                  confirmText: 'Confirm',
                  firstField: notes[i].name,
                  secondField: notes[i].description,
                  onPressed: (name, desc) async {
                    await _viewModel.updateNote(
                      notes[i].id,
                      Note(
                        name: name,
                        description: desc,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBaseDialog(
          confirmText: 'Add',
          onPressed: (name, desc) async {
            await _viewModel.addNote(
              Note(
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
    // _subscription?.cancel();
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
            title: const Text('New note'),
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
}
