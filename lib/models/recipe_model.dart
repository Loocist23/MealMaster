class Recipe {
  final String id;
  final String name;
  final String description;

  Recipe({required this.id, required this.name, required this.description});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
