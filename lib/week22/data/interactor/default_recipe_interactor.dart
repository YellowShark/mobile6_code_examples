import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/week22/domain/interactor/recipe_interactor.dart';
import 'package:mobile6_examples/week22/domain/model/recipe/recipe.dart';
import 'package:mobile6_examples/week22/domain/service/recipe_service.dart';

@Injectable(as: RecipeInteractor)
class DefaultRecipeInteractor implements RecipeInteractor {
  final RecipeService _service;

  DefaultRecipeInteractor(this._service);

  @override
  Future<List<Recipe>> fetchRecipes() => _service.fetchRecipes();
}
