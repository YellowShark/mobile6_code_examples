import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mobile6_examples/week22/domain/service/recipe_service.dart';
import 'package:mobile6_examples/week22/domain/model/recipe/recipe.dart';
import 'package:http/http.dart' as http;

const apiKey = "d8984725e8224950a239ba8a2e1ecf47";

@Singleton(as: RecipeService)
class HttpRecipeService implements RecipeService {
  @override
  Future<List<Recipe>> fetchRecipes() async {
    const url =
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey';
    final request = Uri.parse(url);
    var response = await http.get(request);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    final result = jsonDecode(response.body)['results'] as List<dynamic>;
    return result.map((e) => Recipe(e['image'].toString())).toList();
  }
}
