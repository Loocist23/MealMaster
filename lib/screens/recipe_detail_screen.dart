import 'package:flutter/material.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../services/api_service.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailScreen({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: FutureBuilder<Recipe>(
        future: ApiService().fetchRecipe(recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Recipe not found'));
          } else {
            final recipe = snapshot.data!;
            return FutureBuilder<List<Ingredient>>(
              future: ApiService().fetchIngredients(recipe.ingredientIds),
              builder: (context, ingredientSnapshot) {
                if (ingredientSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (ingredientSnapshot.hasError) {
                  return Center(child: Text('Error: ${ingredientSnapshot.error}'));
                } else if (!ingredientSnapshot.hasData) {
                  return Center(child: Text('Ingredients not found'));
                } else {
                  final ingredients = ingredientSnapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Text(
                            recipe.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Ingredients:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ...ingredients.map((ingredient) => Text(
                            '${ingredient.name}: ${ingredient.quantity} ${ingredient.unit}',
                            style: TextStyle(fontSize: 16),
                          )),
                          SizedBox(height: 16),
                          Text(
                            'Instructions: ${recipe.instructions}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Prep Time: ${recipe.prepTime} minutes',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cook Time: ${recipe.cookTime} minutes',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Servings: ${recipe.servings}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
