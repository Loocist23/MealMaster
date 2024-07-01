class User {
  final String id;
  final String username;
  final String email;
  final String name;
  final String avatar;
  final bool verified;
  final DateTime created;
  final DateTime updated;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.avatar,
    required this.verified,
    required this.created,
    required this.updated,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      avatar: json['avatar'],
      verified: json['verified'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }
}
