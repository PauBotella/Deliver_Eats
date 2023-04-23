class Product {
  String name, description, image;
  double price, rating;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['name'],
        description: json['description'],
        image: json['image'],
        price: json['price'].toDouble(),
        rating: json['rating'].toDouble());
  }
}
