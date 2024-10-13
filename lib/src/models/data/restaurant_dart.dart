// models/data/restaurant.dart

class Restaurant {
  final int id;
  final String name;
  final String slug;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int visitorCount;
  final bool activeResto;

  Restaurant({
    required this.id,
    required this.name,
    required this.slug,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.visitorCount,
    required this.activeResto,
  });

  // Factory constructor to create a Restaurant object from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      visitorCount: json['visitor_count'] as int,
      activeResto: json['active_resto'] ==
          1, // Assuming activeResto is 1 or 0 for true/false
    );
  }

  @override
  String toString() {
    return 'Restaurant{id: $id, name: $name, slug: $slug, userId: $userId, visitorCount: $visitorCount}';
  }

  // Method to convert a Restaurant object into JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'visitor_count': visitorCount,
      'active_resto': activeResto ? 1 : 0, // Convert boolean back to 1 or 0
    };
  }
}
