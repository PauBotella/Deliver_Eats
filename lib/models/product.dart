class Product {
  String name, description, image,uid;
  double price, rating;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.uid,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json,String uid) {
    return Product(
        name: json['name'],
        uid: uid,
        description: json['description'],
        image: json['image'],
        price: json['price'].toDouble(),
        rating: json['rating'].toDouble());
  }
}
