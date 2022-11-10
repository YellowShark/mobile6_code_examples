import 'package:flutter/material.dart';
import 'package:mobile6_examples/week8/data/services/network/recipe_service.dart';
import 'package:mobile6_examples/week8/recipe.dart';
import 'package:mobile6_examples/week8/ui/widgets/recipe_card.dart';

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