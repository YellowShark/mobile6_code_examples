import 'package:mobx/mobx.dart';

part 'recipes_store.g.dart'; // Указание для кодогенерации

class RecipesStore = _RecipesStore with _$RecipesStore;

abstract class _RecipesStore with Store {
  final RecipeInteractor _interactor = DefaultRecipeInteractor();
  @observable
  List<Recipe> recipes = [];

  @action
  Future<void> fetchRecipes() async {
    recipes = await _interactor.fetchRecipes();
  }
}

/// Naming Conventions:
/// ** Service **
/// IService Service
/// Service DefaultService/ServiceImpl/_LibName_Service
