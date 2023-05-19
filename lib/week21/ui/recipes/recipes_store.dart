import 'package:mobile6_examples/week21/data/interactor/default_recipe_interactor.dart';
import 'package:mobile6_examples/week21/domain/interactor/recipe_interactor.dart';
import 'package:mobile6_examples/week21/domain/model/recipe/recipe.dart';
import 'package:mobx/mobx.dart';

part 'recipes_store.g.dart'; // Указание для кодогенерации

class RecipesStore = _RecipesStore with _$RecipesStore;

abstract class _RecipesStore with Store {
  final RecipeInteractor _interactor = DefaultRecipeInteractor();
  @observable
  List<Recipe> recipes = [];

  @action
  Future<void> fetchRecipes() async {
    recipes = await _interactor.getRecipes();
  }
}

/// Naming Conventions:
/// ** Service **
/// IService Service
/// Service DefaultService/ServiceImpl/_LibName_Service
