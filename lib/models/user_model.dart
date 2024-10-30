
class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String? avatar; // URL complète pour l'avatar
  final bool verified;
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.avatar,
    required this.verified,
    required this.created,
    required this.updated,
  });

  factory User.fromJson(Map<String, dynamic> json, String? avatar) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: avatar,
      verified: json['verified'] ?? false,
      created: DateTime.parse(json['created'] ?? DateTime.now().toIso8601String()),
      updated: DateTime.parse(json['updated'] ?? DateTime.now().toIso8601String()),
    );
  }
}