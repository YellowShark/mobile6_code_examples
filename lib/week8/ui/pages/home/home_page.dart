import 'package:flutter/material.dart';
import 'package:mobile6_examples/week8/data/services/network/recipe_service.dart';
import 'package:mobile6_examples/week8/recipe.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];
  final _recipeService = RecipeService();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App bar"),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (_, i) => RecipeCard(
          recipe: recipes[i],
        ),
      ),
    );
  }

  Future fetchRecipes() async {
    final data = await _recipeService.fetchRecipes();
    setState(() => recipes = data);
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(recipe.imageUrl),
        Text(recipe.title),
      ],
    );
  }
}