import 'package:mobile6_examples/objectbox.g.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:objectbox/objectbox.dart';

class NotesRepository {
  late final Store _store;
  late final Box<Note> _box;

  List<Note> get notes => _box.getAll()..sort((a, b) => b.id.compareTo(a.id));

  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Note>();
  }

  Future addNote(Note note) async {
    await _box.putAsync(note);
  }

  Future update(int id, Note note) async {
    _box.remove(id);
    await _box.putAsync(note);
  }
}