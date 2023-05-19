import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:mobile6_examples/week16/repository/notes_repository.dart';
import 'package:mobile6_examples/week16/utils/dialog_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _notesRepo = NotesRepository();
  late var _notes = <Note>[];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _notesRepo.initDB().whenComplete(
        () => _subscription = _notesRepo.boxStreamNotes.listen((list) {
              setState(() => _notes = list);
            }));
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
            onPressed: () => showBaseDialog(
              context: context,
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
        onPressed: () => showBaseDialog(
          context: context,
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
