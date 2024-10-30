import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/ingredient_model.dart';
import '../models/unit_model.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';

class CreateRecipeScreen extends StatefulWidget {
  @override
  _CreateRecipeScreenState createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  String name = '';
  String description = '';
  String instructions = '';
  int prepTime = 0;
  int cookTime = 0;
  int servings = 1;
  int difficultyLevel = 1;

  List<Ingredient> ingredients = [];
  List<Unit> units = [];
  List<Map<String, dynamic>> selectedIngredients = [];
  List<XFile> images = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ingredients = await apiService.fetchIngredients();
    units = await apiService.fetchUnits();
    setState(() {});
  }

  Future<void> _pickImages() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(pickedFile);
      });
    }
  }


  void _addIngredient(Ingredient ingredient, String quantity, Unit unit) {
    setState(() {
      selectedIngredients.add({
        'ingredient': ingredient,
        'quantity': quantity,
        'unit': unit,
      });
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convert `images` to a list of paths for the API
      List<String> imagePaths = images.map((image) => image.path).toList();

      Recipe newRecipe = Recipe(
        id: '',
        name: name,
        description: description,
        type: 'main',
        images: imagePaths,
        ingredientIds: selectedIngredients.map<String>((ing) => ing['ingredient'].id as String).toList(),
        instructions: instructions,
        prepTime: prepTime,
        cookTime: cookTime,
        servings: servings,
        difficultyLevel: difficultyLevel,
        quantities: {
          for (var ing in selectedIngredients)
            ing['ingredient'].id: {
              'quantity': ing['quantity'],
              'unit': ing['unit'].abbreviation,
            }
        },
      );

      await apiService.addRecipe(newRecipe);
      Navigator.pop(context);
    }
  }

  void _openAddIngredientDialog() {
    String searchQuery = '';
    String? selectedIngredientId;
    String quantity = '';
    String? selectedUnitId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Filtrer les ingrédients en fonction de la recherche
            List<Ingredient> filteredIngredients = ingredients
                .where((ingredient) =>
                ingredient.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return AlertDialog(
              title: Text('Add Ingredient'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de recherche
                  TextField(
                    decoration: InputDecoration(labelText: 'Search Ingredient'),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // Dropdown avec les ingrédients filtrés
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Ingredient'),
                    items: filteredIngredients.map((ingredient) {
                      return DropdownMenuItem(
                        value: ingredient.id,
                        child: Text(ingredient.name),
                      );
                    }).toList(),
                    onChanged: (value) => selectedIngredientId = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => quantity = value,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Unit'),
                    items: units.map((unit) {
                      return DropdownMenuItem(
                        value: unit.id,
                        child: Text(unit.abbreviation),
                      );
                    }).toList(),
                    onChanged: (value) => selectedUnitId = value,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (selectedIngredientId != null &&
                        selectedUnitId != null &&
                        quantity.isNotEmpty) {
                      final selectedIngredient =
                      ingredients.firstWhere((ing) => ing.id == selectedIngredientId);
                      final selectedUnit = units.firstWhere((unit) => unit.id == selectedUnitId);
                      _addIngredient(selectedIngredient, quantity, selectedUnit);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Recipe Name'),
                validator: (value) => value!.isEmpty ? 'Enter a recipe name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Instructions'),
                maxLines: 5,
                onSaved: (value) => instructions = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preparation Time (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => prepTime = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cooking Time (minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => cookTime = int.tryParse(value!) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Servings'),
                keyboardType: TextInputType.number,
                onSaved: (value) => servings = int.tryParse(value!) ?? 1,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Difficulty Level'),
                value: difficultyLevel,
                items: List.generate(5, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  );
                }),
                onChanged: (value) => setState(() => difficultyLevel = value ?? 1),
              ),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Add Images'),
              ),
              // Display selected images
              Wrap(
                spacing: 8.0,
                children: images
                    .map((image) => Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ))
                    .toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _openAddIngredientDialog,
                child: Text('Add Ingredient'),
              ),
              // Display selected ingredients
              ...selectedIngredients.map((ing) {
                return ListTile(
                  title: Text('${ing['ingredient'].name}: ${ing['quantity']} ${ing['unit'].abbreviation}'),
                );
              }).toList(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
