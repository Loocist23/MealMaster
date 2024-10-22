class Recipe {
  final String id;
  final String name;
  final String description;
  final String type;
  final List<String> images;
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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://192.168.0.28/api/files';

    // Construire les URLs des images
    List<String> constructImageUrls(String collectionId, String recordId, List<dynamic> images) {
      return images.map((image) {
        return '$baseUrl/$collectionId/$recordId/$image';
      }).toList();
    }

    List<String> imageUrls = [];
    if (json['images'] != null && json['images'].isNotEmpty) {
      imageUrls = constructImageUrls(json['collectionId'], json['id'], json['images']);
    }

    return Recipe(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description',
      type: json['type'] ?? 'Other',
      images: imageUrls,
      ingredientIds: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? 'No instructions provided',
      prepTime: json['prep_time'] != null ? json['prep_time'] as int : 0,
      cookTime: json['cook_time'] != null ? json['cook_time'] as int : 0,
      servings: json['servings'] != null ? json['servings'] as int : 1,
      difficultyLevel: json['difficulty_level'] != null ? json['difficulty_level'] as int : 1,
      quantities: json['quantities'] ?? {}, // Quantités liées aux ingrédients
    );
  }
}
