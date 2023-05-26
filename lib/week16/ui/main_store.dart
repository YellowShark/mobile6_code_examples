import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/week16/model/note.dart';
import 'package:mobile6_examples/week16/repository/notes_repository.dart';
import 'package:mobx/mobx.dart';

part 'main_store.g.dart'; // Указание для кодогенерации

@Injectable()
class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  final NotesRepository _repository;

  @observable
  var notes = <Note>[];

  _MainStore(this._repository);

  Future<void> getNotes() async {
    notes = _repository.notes;
    // _repository.boxStreamNotes.listen((list) {
    //   notes = list;
    // });
  }

  Future addNote(Note note) => _repository.addNote(note);

  Future updateNote(int id, Note note) => _repository.update(id, note);
}
