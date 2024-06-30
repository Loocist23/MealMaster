class Ingredient {
  final String id;
  final String name;
  final int quantity;
  final String unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }
}
