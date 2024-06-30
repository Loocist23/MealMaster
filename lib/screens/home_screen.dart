import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';
import '../widgets/recipe_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> futureRecipes;
  String selectedFilter = '';

  @override
  void initState() {
    super.initState();
    futureRecipes = ApiService().fetchRecipes();
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
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FilterChip(
                  label: Text('All'),
                  selected: selectedFilter == '',
                  onSelected: (bool selected) {
                    applyFilter('');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Vegan'),
                  selected: selectedFilter == 'vegan',
                  onSelected: (bool selected) {
                    applyFilter('vegan');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Vegetarian'),
                  selected: selectedFilter == 'vegetarian',
                  onSelected: (bool selected) {
                    applyFilter('vegetarian');
                  },
                ),
                SizedBox(width: 8),
                FilterChip(
                  label: Text('Meat'),
                  selected: selectedFilter == 'meat',
                  onSelected: (bool selected) {
                    applyFilter('meat');
                  },
                ),
                // Ajouter d'autres filtres si nécessaire
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<Recipe>>(
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              // Navigation vers la page de détail se fait dans RecipeCard
                            },
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
    );
  }
}
