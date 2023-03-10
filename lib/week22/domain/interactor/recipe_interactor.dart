import 'package:mobile6_examples/week22/domain/model/recipe/recipe.dart';

abstract class RecipeInteractor {
  Future<List<Recipe>> fetchRecipes();
}