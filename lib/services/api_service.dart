import 'dart:convert';

import 'package:http/http.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/unit_model.dart';
import '../models/user_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';



class ApiService {
  final PocketBase pb = PocketBase('http://192.168.1.89:8090');
  static const String baseUrl = 'http://192.168.1.89:8090/api/files';

  // Méthode pour générer une URL complète pour les fichiers
  String constructFileUrl(String collectionId, String recordId, String filename) {
    return '$baseUrl/$collectionId/$recordId/$filename';
  }

  // Récupère le profil de l'utilisateur connecté

  // Méthode pour récupérer le profil utilisateur avec URL complète de l'avatar
  Future<User> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final record = await pb.collection('users').getOne(userId!);

    // Générer l'URL complète de l'avatar
    final avatar = record.data['avatar'] != null
        ? constructFileUrl(record.collectionId, record.id, record.data['avatar'])
        : null;
    return User.fromJson(record.toJson(), avatar);
  }

  // Met à jour le profil de l'utilisateur
  Future<void> updateUserProfile({
    required String userId,
    required String name,
    String? avatarPath,
  }) async {
    final body = <String, dynamic>{
      "name": name,
    };

    List<http.MultipartFile> files = [];
    if (avatarPath != null) {
      files.add(await http.MultipartFile.fromPath(
        'avatar', // Nom du champ pour l'avatar dans PocketBase
        avatarPath,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      await pb.collection('users').update(
        userId,
        body: body,
        files: files, // Assurez-vous que files est toujours une liste non nulle
      );
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour du profil : $e");
    }
  }

  // Méthode pour récupérer les recettes avec URLs complètes des images
  Future<List<Recipe>> fetchRecipes({String? type}) async {
    final response = await pb.collection('recipes').getFullList();

    // Transformer chaque item en Recipe avec URLs d'images complètes
    List<Recipe> recipes = response.map((item) {
      final images = (item.data['images'] as List<dynamic>).map((img) =>
          constructFileUrl(item.collectionId, item.id, img as String)).toList();
      return Recipe.fromJson(item.toJson(), images);
    }).toList();

    if (type != null && type.isNotEmpty) {
      recipes = recipes.where((recipe) => recipe.type == type).toList();
    }

    return recipes;
  }

  Future<Recipe> fetchRecipe(String id) async {
    final record = await pb.collection('recipes').getOne(id);
    final images = (record.data['images'] as List<dynamic>).map((img) =>
        constructFileUrl(record.collectionId, record.id, img as String)).toList();
    return Recipe.fromJson(record.toJson(), images);
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      final body = <String, dynamic>{
        "name": recipe.name,
        "description": recipe.description,
        "prep_time": recipe.prepTime,
        "cook_time": recipe.cookTime,
        "servings": recipe.servings,
        "difficulty_level": recipe.difficultyLevel,
        "instructions": recipe.instructions,
        "quantities": recipe.quantities,
        "ingredients": recipe.ingredientIds,
      };

      // Ajouter les images en utilisant MultipartFile.fromPath
      final files = await Future.wait(recipe.images.map((imagePath) async {
        return await http.MultipartFile.fromPath(
          'images', // Le nom du champ attendu par PocketBase
          imagePath,
          contentType: MediaType('image', 'jpeg'), // Ajuste le type MIME en fonction de l'image
        );
      }).toList());

      // Envoie la requête avec le body et les fichiers
      final record = await pb.collection('recipes').create(
        body: body,
        files: files,
      );

      print("Record créé avec succès: ${record.id}");
    } catch (e) {
      throw Exception("Erreur lors de l'ajout de la recette : $e");
    }
  }


  // Méthode pour récupérer la liste complète des ingrédients
  Future<List<Ingredient>> fetchIngredients() async {
    final records = await pb.collection('ingredients').getFullList(sort: 'name');
    return records.map((item) => Ingredient.fromJson(item.toJson())).toList();
  }

  // Méthode pour récupérer la liste complète des unités
  Future<List<Unit>> fetchUnits() async {
    final records = await pb.collection('units').getFullList(sort: 'name');
    return records.map((item) => Unit.fromJson(item.toJson())).toList();
  }

  Future<List<Ingredient>> fetchIngredientsByIds(List<String> ingredientIds) async {
    if (ingredientIds.isEmpty) {
      return [];
    }

    // Crée un filtre pour récupérer les ingrédients par leurs IDs
    final filter = ingredientIds.map((id) => 'id="$id"').join(' || ');
    final response = await pb.collection('ingredients').getFullList(filter: filter);

    return response.map((item) => Ingredient.fromJson(item.toJson())).toList();
  }

  Future<String?> login(String email, String password) async {
    final authData = await pb.collection('users').authWithPassword(email, password);
    return authData.record?.id;
  }

  Future<void> logout() async {
    pb.authStore.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
