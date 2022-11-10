import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile6_examples/week8/recipe.dart';

const apiKey = 'd8984725e8224950a239ba8a2e1ecf47';

class RecipeService {
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=pasta&number=1',
      ),
    );
    print(response.statusCode);
    print(response.body);
    final result = jsonDecode(response.body)['results'] as List<dynamic>;
    return result.map((json) => Recipe.fromJson(json)).toList();
  }
}
