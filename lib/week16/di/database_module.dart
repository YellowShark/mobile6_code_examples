import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

@module
abstract class DatabaseModule {
  @singleton
  @preResolve
  Future<Store> get store => openStore();
}