import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/user_model.dart';

class ApiService {
  final PocketBase pb = PocketBase('http://192.168.1.48:8090');

  Future<List<Recipe>> fetchRecipes({String? type}) async {
    final response = await pb.collection('recipes').getFullList();

    List<Recipe> recipes = response.map((item) => Recipe.fromJson(item.toJson())).toList();

    if (type != null && type.isNotEmpty) {
      recipes = recipes.where((recipe) => recipe.type == type).toList();
    }

    return recipes;
  }

  Future<Recipe> fetchRecipe(String id) async {
    final record = await pb.collection('recipes').getOne(id);
    return Recipe.fromJson(record.toJson());
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

  Future<String> login(String email, String password) async {
    final authData = await pb.collection('users').authWithPassword(email, password);
    return pb.authStore.model.id;
  }

  Future<void> logout() async {
    pb.authStore.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
