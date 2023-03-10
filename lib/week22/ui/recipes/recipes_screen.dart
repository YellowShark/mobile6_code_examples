import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile6_examples/week22/di/config.dart';
import 'package:mobile6_examples/week22/ui/recipes/recipes_store.dart';

class RecipesScreen extends StatelessWidget {
  final RecipesStore _viewModel = getIt<RecipesStore>();

  RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _fetchData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Observer(
        builder: (_) {
          final data = _viewModel.recipes;
          return ListView.builder(
            itemBuilder: (_, i) => Image.network(data[i].image),
            itemCount: data.length,
          );
        },
      ),
    );
  }

  Future<void> _fetchData() async {
    await _viewModel.fetchRecipes();
  }
}
