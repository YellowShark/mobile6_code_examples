import 'package:mobile6_examples/week21/domain/model/recipe/recipe.dart';

abstract class RecipeInteractor {
  Future<List<Recipe>> getRecipes();
}
