import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card_widget.dart';
import '../widgets/filter_chip_widget.dart';
import 'login_screen.dart';
import 'recipe_detail_screen.dart'; // Importer la page de détail
import 'create_recipe_screen.dart'; // Importer la page de création

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Recipe>>? futureRecipes;
  String selectedFilter = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      setState(() {
        futureRecipes = ApiService().fetchRecipes();
      });
    }
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      futureRecipes = ApiService().fetchRecipes(type: filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MealMaster - Recipes'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: [
                  FilterChipWidget(
                    label: 'All',
                    isSelected: selectedFilter == '',
                    onSelected: (selected) {
                      applyFilter('');
                    },
                  ),
                  FilterChipWidget(
                    label: 'Vegan',
                    isSelected: selectedFilter == 'vegan',
                    onSelected: (selected) {
                      applyFilter('vegan');
                    },
                  ),
                  FilterChipWidget(
                    label: 'Vegetarian',
                    isSelected: selectedFilter == 'vegetarian',
                    onSelected: (selected) {
                      applyFilter('vegetarian');
                    },
                  ),
                  FilterChipWidget(
                    label: 'Meat',
                    isSelected: selectedFilter == 'meat',
                    onSelected: (selected) {
                      applyFilter('meat');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: futureRecipes == null
                  ? CircularProgressIndicator()
                  : FutureBuilder<List<Recipe>>(
                future: futureRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No recipes found');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final recipe = snapshot.data![index];

                        final String name = recipe.name;
                        final String difficulty = recipe.difficultyLevel != null
                            ? recipe.difficultyLevel.toString()
                            : 'Unknown';
                        final String servings = recipe.servings != null
                            ? recipe.servings.toString()
                            : 'Unknown';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Difficulty: $difficulty/5'),
                                  Text('Servings: $servings'),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailScreen(
                                          recipeId: recipe.id,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRecipeScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create Recipe',
      ),
    );
  }
}
