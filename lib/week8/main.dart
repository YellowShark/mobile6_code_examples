import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile6_examples/week7/recipe.dart';

const apiKey = 'd8984725e8224950a239ba8a2e1ecf47';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> recipes = [];

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
    final response = await http.get(
      Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?apiKey=$apiKey&query=pasta&number=1',
      ),
    );
    print(response.statusCode);
    print(response.body);
    final result = jsonDecode(response.body)['results'] as List<dynamic>;
    final data = result.map((json) => Recipe.fromJson(json)).toList();
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
