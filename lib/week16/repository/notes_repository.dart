import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/objectbox.g.dart';
import 'package:mobile6_examples/week16/di/config.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:objectbox/objectbox.dart';

@LazySingleton()
class NotesRepository {
  final Store _store = getIt<Store>();
  late final Box<Note> _box;
  final _controller = StreamController<List<Note>>.broadcast();

  NotesRepository() {
    _box = _store.box<Note>();
    _updateStream();
  }

  List<Note> get notes => _box.getAll()..sort((a, b) => b.id.compareTo(a.id));

  Stream<List<Note>> get streamNotes => _controller.stream;

  Stream<List<Note>> get boxStreamNotes =>
      _box.query().watch(triggerImmediately: true).map((query) => query.find());

  Future addNote(Note note) async {
    await _box.putAsync(note);
    await _updateStream();
  }

  Future update(int id, Note note) async {
    _box.remove(id);
    await _box.putAsync(note);
    await _updateStream();
  }

  Future _updateStream() async {
    _controller.add(notes);
  }
}
