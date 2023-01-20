import 'package:flutter/material.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:mobile6_examples/week16/repository/notes_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _notesRepo = NotesRepository();
  late var _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    _notesRepo
        .initDB()
        .whenComplete(() => setState(() => _notes = _notesRepo.notes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
            _notes[i].name,
          ),
          subtitle: Text(
            _notes[i].description,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showBaseDialog(
              confirmText: 'Confirm',
              firstField: _notes[i].name,
              secondField: _notes[i].description,
              onPressed: (name, desc) async {
                await _notesRepo.update(
                  _notes[i].id,
                  Note(
                    name: name,
                    description: desc,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBaseDialog(
          confirmText: 'Add',
          onPressed: (name, desc) async {
            await _notesRepo.addNote(
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
                  await onPressed(nameController.text, descController.text);
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: Text(confirmText),
              )
            ],
          );
        },
      );
}
