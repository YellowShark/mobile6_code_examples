import 'dart:async';

import 'package:mobile6_examples/objectbox.g.dart';
import 'package:mobile6_examples/week16/model/todo.dart';
import 'package:objectbox/objectbox.dart';

class TodoRepository {
  late final Store _store;
  late final Box<Todo> _box;

  //final StreamController<List<Todo>> _controller = StreamController.broadcast();

  //_box.query(Todo_.name.contains('todo'))

  Stream<List<Todo>> todoListStream() => _box.query()
      .watch(triggerImmediately: true)
      .map((query) => query.find());
  
  Future initDB() async {
    _store = await openStore();
    _box = _store.box<Todo>();
    //_updateStream();
  }

  List<Todo> getAll() => _box.getAll().reversed.toList();

  Future create(Todo todo) async {
    await _box.putAsync(todo);
    //_updateStream();
  }

  Future update(int id, Todo todo) async {
    _box.remove(id);
    await _box.putAsync(todo);
    //_updateStream();
  }

  Future delete(int id) async {
    _box.remove(id);
    //_updateStream();
  }

  // void _updateStream() {
  //   _controller.add(getAll());
  // }
}
