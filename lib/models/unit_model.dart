class Unit {
  final String id;
  final String name;
  final String abbreviation;

  Unit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      abbreviation: json['symbol'] ?? '',
    );
  }
}
