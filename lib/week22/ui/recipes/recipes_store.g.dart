// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecipesStore on _RecipesStore, Store {
  late final _$recipesAtom =
      Atom(name: '_RecipesStore.recipes', context: context);

  @override
  List<Recipe> get recipes {
    _$recipesAtom.reportRead();
    return super.recipes;
  }

  @override
  set recipes(List<Recipe> value) {
    _$recipesAtom.reportWrite(value, super.recipes, () {
      super.recipes = value;
    });
  }

  late final _$fetchRecipesAsyncAction =
      AsyncAction('_RecipesStore.fetchRecipes', context: context);

  @override
  Future<void> fetchRecipes() {
    return _$fetchRecipesAsyncAction.run(() => super.fetchRecipes());
  }

  @override
  String toString() {
    return '''
recipes: ${recipes}
    ''';
  }
}
