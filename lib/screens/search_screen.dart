import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe_model.dart';
import 'package:diacritic/diacritic.dart'; // Utilitaire pour enlever les accents

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Recipe> searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Normaliser une chaîne pour la rendre insensible à la casse et aux accents
  String _normalize(String text) {
    return removeDiacritics(text).toLowerCase();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      if (_searchController.text.isNotEmpty) {
        _searchRecipes(_searchController.text);
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    });
  }

  Future<void> _searchRecipes(String query) async {
    try {
      final results = await apiService.fetchRecipes(type: null);
      final normalizedQuery = _normalize(query);

      // Filtrer les résultats en normalisant également les noms des recettes
      final filteredResults = results
          .where((recipe) => _normalize(recipe.name).contains(normalizedQuery))
          .toList();

      setState(() {
        searchResults = filteredResults;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la recherche : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recherche de Recettes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher une recette',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('Aucune recette trouvée'))
                  : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final recipe = searchResults[index];
                  return ListTile(
                    title: Text(recipe.name),
                    subtitle: Text(recipe.description),
                    onTap: () {
                      // Naviguer vers les détails de la recette si nécessaire
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
