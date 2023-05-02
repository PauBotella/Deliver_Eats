class Product {
  String name, description, image,id;
  double price, rating;

  Product({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.id,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json,String uid) {
    return Product(
        name: json['name'],
        id: uid,
        description: json['description'],
        image: json['image'],
        price: json['price'].toDouble(),
        rating: json['rating'].toDouble());
  }

   Map<String,dynamic> toMap() {

    return {
      'name' : name,
      'description' : description,
      'image' : image,
      'price' : price,
      'rating' : rating,
    };
  }

}
