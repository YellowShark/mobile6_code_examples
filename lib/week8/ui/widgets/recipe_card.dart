import 'package:flutter/material.dart';
import 'package:mobile6_examples/week8/recipe.dart';

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