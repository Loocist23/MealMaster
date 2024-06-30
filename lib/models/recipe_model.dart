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
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    const baseUrl = 'http://192.168.0.28/api/files';
    List<String> constructImageUrls(String collectionId, String recordId, List<dynamic> images) {
      return images.map((image) {
        return '$baseUrl/$collectionId/$recordId/$image';
      }).toList();
    }

    List<String> imageUrls = [];
    if (json['image'] != null && json['image'].isNotEmpty) {
      imageUrls = constructImageUrls(json['collectionId'], json['id'], json['image']);
    }

    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      images: imageUrls,
      ingredientIds: List<String>.from(json['ingredients']),
      instructions: json['instructions'],
      prepTime: json['prep_time'],
      cookTime: json['cook_time'],
      servings: json['servings'],
    );
  }
}
