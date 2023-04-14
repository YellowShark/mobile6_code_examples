import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  @Id()
  int id;
  String name;
  String description;

  Todo({
    this.id = 0,
    required this.name,
    required this.description,
  });
}
