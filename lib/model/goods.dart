class Good {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  late final int quantity; // Updated to non-nullable
  final String image;

  Good({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.quantity,
    required this.image,
  });

  factory Good.fromJson(Map<String, dynamic> json) {
    return Good(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] != null ? json['price'].toDouble() : 0.0,
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'quantity': quantity,
      'image': image,
    };
  }
}
