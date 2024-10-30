import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../services/api_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe> futureRecipe;
  late Future<List<Ingredient>> futureIngredients;

  @override
  void initState() {
    super.initState();
    futureRecipe = ApiService().fetchRecipe(widget.recipeId);
    futureRecipe.then((recipe) {
      // Une fois que la recette est récupérée, on lance la récupération des ingrédients
      futureIngredients = ApiService().fetchIngredientsByIds(recipe.ingredientIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: FutureBuilder<Recipe>(
        future: futureRecipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Recipe not found'));
          } else {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Affichage des images
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipe.images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            recipe.images[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/placeholder_image.png');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(recipe.description),
                  SizedBox(height: 16),
                  // Affichage des ingrédients
                  Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder<List<Ingredient>>(
                    future: futureIngredients,
                    builder: (context, ingredientSnapshot) {
                      if (ingredientSnapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (ingredientSnapshot.hasError) {
                        return Text('Error: ${ingredientSnapshot.error}');
                      } else if (!ingredientSnapshot.hasData || ingredientSnapshot.data!.isEmpty) {
                        return Text('No ingredients found.');
                      } else {
                        final ingredients = ingredientSnapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ingredients.map((ingredient) {
                            final quantityData = recipe.quantities[ingredient.id];
                            final quantity = quantityData != null ? quantityData['quantity'] : 'Unknown';
                            final unit = quantityData != null ? quantityData['unit'] : '';
                            return Text(
                              '${ingredient.name}: $quantity $unit',
                              style: TextStyle(fontSize: 16),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  // Instructions
                  Text('Instructions: ${recipe.instructions}'),
                  SizedBox(height: 16),
                  // Détails supplémentaires
                  Text('Prep Time: ${recipe.prepTime} minutes'),
                  Text('Cook Time: ${recipe.cookTime} minutes'),
                  Text('Servings: ${recipe.servings}'),
                  Text('Difficulty Level: ${recipe.difficultyLevel}/5'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

