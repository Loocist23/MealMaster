class Recipe {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> images; // URLs complètes
  final List<String> ingredientIds;
  final String instructions;
  final int prepTime;
  final int cookTime;
  final int servings;
  final int difficultyLevel;
  final Map<String, dynamic> quantities;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.images,
    required this.ingredientIds,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.difficultyLevel,
    required this.quantities,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, List<String> images) {
    return Recipe(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      type: json['type'] ?? 'Other',
      images: images,
      ingredientIds: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? 'No instructions provided',
      prepTime: json['prep_time'] ?? 0,
      cookTime: json['cook_time'] ?? 0,
      servings: json['servings'] ?? 1,
      difficultyLevel: json['difficulty_level'] ?? 1,
      quantities: json['quantities'] ?? {},
    );
  }
}