import 'package:mobile6_examples/week21/data/service/http_recipe_service.dart';
import 'package:mobile6_examples/week21/domain/interactor/recipe_interactor.dart';
import 'package:mobile6_examples/week21/domain/model/recipe/recipe.dart';
import 'package:mobile6_examples/week21/domain/service/recipe_service.dart';

class DefaultRecipeInteractor implements RecipeInteractor {
  final RecipeService _service = HttpRecipeService();

  @override
  Future<List<Recipe>> fetchRecipes() => _service.fetchRecipes();
}
