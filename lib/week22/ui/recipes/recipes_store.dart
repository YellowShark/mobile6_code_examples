import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/week22/domain/interactor/recipe_interactor.dart';
import 'package:mobile6_examples/week22/domain/model/recipe/recipe.dart';
import 'package:mobx/mobx.dart';

part 'recipes_store.g.dart'; // Указание для кодогенерации

@Injectable()
class RecipesStore = _RecipesStore with _$RecipesStore;

abstract class _RecipesStore with Store {
  final RecipeInteractor _interactor;
  @observable
  List<Recipe> recipes = [];

  _RecipesStore(this._interactor);

  @action
  Future<void> fetchRecipes() async {
    recipes = await _interactor.fetchRecipes();
  }
}

/// Naming Conventions:
/// ** Service **
/// IService Service
/// Service DefaultService/ServiceImpl/_LibName_Service
